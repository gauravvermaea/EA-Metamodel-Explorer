from flask import Flask, jsonify


def create_app():
    app = Flask(__name__)

    @app.route("/api/test", methods=["GET"])
    def sample_route():
        return jsonify({"message": "This is a sample route"})

    return app


app = create_app()

if __name__ == "__main__":
    app.run(
        debug=True,
        host='0.0.0.0',
        port=5000
    )