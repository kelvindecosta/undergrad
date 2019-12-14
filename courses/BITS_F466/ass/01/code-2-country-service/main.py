from flask import Flask
from flask import jsonify
import phonenumbers
import country_converter


app = Flask(__name__)

# Calling Code -> Country
@app.route("/api/<int:code>")
def country(code):
    code = phonenumbers.region_code_for_country_code(code)
    print(code)
    if code == "ZZ":
        return jsonify({"message": "Resource not found"}), 404
    return jsonify({"country": country_converter.convert(code, to="short_name")})


# Errors
@app.errorhandler(404)
def page_not_found(e):
    return jsonify({"message": "Resource not found"}), 404


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
