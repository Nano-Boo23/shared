from flask import Flask, render_template, request, make_response
import socket
import psycopg2
import random

app = Flask(__name__)

def get_db_connection():
    conn = psycopg2.connect(
        host="db",   # nombre del servicio en docker-compose
        database="db_proj3",
        user="user",
        password="user"
    )
    return conn

def get_data():
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("""
        SELECT voto, COUNT(*) AS total
        FROM votos
        GROUP BY voto
        ORDER BY total DESC
        LIMIT 2;
    """)
    votos = cur.fetchall()
    data = {"option_a": {}, "option_b": {}}
    data["option_a"]["name"] = votos[0][0]
    data["option_b"]["name"] = votos[1][0]
    data["option_a"]["total"] = votos[0][1]
    data["option_b"]["total"] = votos[1][1]
    cur.close()
    conn.close()
    return data

@app.route("/", methods = ['GET','POST'])
def index():
    vote = None
    hostname = socket.gethostname()
    voter_id = request.cookies.get('voter_id')
    if not voter_id:
        voter_id = hex(random.getrandbits(64))[2:-1]

    if request.method == 'POST':
        vote = request.form['vote']
        conn = get_db_connection()
        cur = conn.cursor()

        if vote == "custom":
            vote = request.form.get('custom_vote', '').strip()


        if vote:
            # Inserció directa; pero substitueix valor nou si hi
            # ha un conflicte de primary keys (el votant ha
            # canviat el seu vot)
            cur.execute("""
                INSERT INTO votos (id, voto)
                VALUES (%s, %s)
                ON CONFLICT (id)
                DO UPDATE SET
                    voto = EXCLUDED.voto;""",
                (voter_id, vote)
            )
            conn.commit()
            cur.close()

    data = get_data()

    resp = make_response(render_template(
        'index.html',
        data=data,
        hostname=hostname,
        vote=vote,
    ))

    resp.set_cookie('voter_id', voter_id)
    return resp

app.run(host="0.0.0.0", port=5000, debug=True)
