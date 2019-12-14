from flask import Flask
from flask import jsonify
import phonenumbers
import country_converter


app = Flask(__name__)

# Country -> Calling Code
@app.route("/api/<country>")
def code(country):
    country = country_converter.convert(country, to="ISO2")
    if country == "not found":
        return jsonify({"message": "Resource not found"}), 404
    return jsonify({"code": phonenumbers.country_code_for_region(country)})


# Errors
@app.errorhandler(404)
def page_not_found(e):
    return jsonify({"message": "Resource not found"}), 404


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5001, debug=True)
