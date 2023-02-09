#!/usr/bin/env python3

from flask import Flask, send_from_directory, render_template
# from flask_debugtoolbar import DebugToolbarExtension
import json
import logging
from pathlib import Path

root = logging.getLogger()
root.setLevel(logging.DEBUG)

app = Flask("ipxe-httpd", template_folder=".")
app.config.from_file("config.json", load=json.load)
file = Path("config_local.json")
if file.is_file():
    app.config.from_file("config_local.json", load=json.load)

# toolbar = DebugToolbarExtension(app)


@app.route("/")
def root():
    return "<html><body><p>iPXE HTTP server</p></body></html>"


@app.route('/boot/<path:path>')
def path_boot(path):
    filename = f"ipxe/boot/{path}"
    file = Path(filename)
    if file.is_file():
        return send_from_directory('ipxe/boot', path)
    else:
        templatename = f"ipxe/boot/{path}.j2"
        file = Path(templatename)
        if file.is_file():
            logging.debug(f"found template {templatename}")
            config = app.config.get_namespace('IPXE', trim_namespace=False)
            return render_template(templatename, **config)
        else:
            return ('', 204)


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8080)
