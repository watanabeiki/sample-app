from flask import Flask, render_template

sample = Flask(__name__)

@sample.route("/")
def main():
    return render_template("index.html")

if __name__ == "__main__":
    # 关键参数：单线程、禁止自动重载、禁止多进程
    sample.run(host="0.0.0.0", port=5050, threaded=False, processes=1, use_reloader=False)
