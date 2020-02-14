from flask import Flask
app = Flask(__name__)
@app.route('/')
def hello():
    return "hello docker by l00379880"

def main():
    app.run()

if __name__ == '__main__':
    main()