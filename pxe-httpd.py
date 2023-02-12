#!/usr/bin/env python3

from flask import Flask, send_from_directory, render_template
# from flask_debugtoolbar import DebugToolbarExtension
import json
import logging
from pathlib import Path
import os

app = Flask('pxe-httpd', template_folder='.')

rootDir = os.environ.get('ROOT_DIR')


@app.route('/')
def root():
    return '<html><body><p>iPXE HTTP server</p></body></html>'


@app.route('/iso/<path:path>')
def iso(path):
    logging.debug(f'loading iso {path}')
    return send_from_directory(f'{rootDir}/iso', path)


@app.route('/boot/<path:path>')
def path_boot(path):
    if path.startswith('ubuntu'):
        return path_boot_ubuntu(path)
    else:
        return path_boot_misc(path)


@app.route('/boot/ubuntu-<string:version>.ipxe')
def path_boot_ubuntu_version(version):
    templatename = f'{rootDir}/boot/ubuntu-version.ipxe.j2'
    if not Path(templatename).is_file():
        logging.error('menu template "ubuntu-version.ipxe.j2" is missing')
        return ('', 500)
    logging.debug(f'call path_boot_ubuntu_version: {version}')
    ubuntuDir = Path(f"{rootDir}/iso/ubuntu/{version}")
    if ubuntuDir.is_dir():
        templatename = f'{rootDir}/boot/ubuntu-version.ipxe.j2'
        return render_template(templatename, version=version)
    else:
        return ('', 204)


def path_boot_ubuntu(path):
    logging.debug('call path_boot_ubuntu')
    filename = f'{rootDir}/boot/{path}'
    file = Path(filename)
    if file.is_file():
        return send_from_directory(f'{rootDir}/boot', path)
    else:
        templatename = f'{rootDir}/boot/{path}.j2'
        file = Path(templatename)
        if file.is_file():
            logging.debug(f'found ubuntu template {templatename}')
            ubuntu = []
            ubuntuDir = Path(f"{rootDir}/iso/ubuntu")
            if ubuntuDir.is_dir():
                dirlist = [item for item in os.listdir(ubuntuDir.as_posix()) if os.path.isdir(os.path.join(ubuntuDir.as_posix(), item))]
                for version in dirlist:
                    ubuntu.append({'version': version})
            return render_template(templatename, ubuntu_list=ubuntu)
        else:
            return ('', 204)


def path_boot_misc(path):
    filename = f'{rootDir}/boot/{path}'
    file = Path(filename)
    if file.is_file():
        return send_from_directory(f'{rootDir}/boot', path)
    else:
        templatename = f'{rootDir}/boot/{path}.j2'
        file = Path(templatename)
        if file.is_file():
            logging.debug(f'found template {templatename}')
            config = app.config.get_namespace('PXE', trim_namespace=False)
            return render_template(templatename, **config)
        else:
            return ('', 204)


def main():
    app.config['PXE_HTTP_PORT'] = os.environ.get('HTTP_PORT')
    app.config.from_file('config.json', load=json.load)
    file = Path('config_local.json')
    if file.is_file():
        app.config.from_file('config_local.json', load=json.load)

    # toolbar = DebugToolbarExtension(app)

    logging.getLogger().setLevel(logging.DEBUG)

    app.run(host='0.0.0.0', port=os.environ.get('HTTP_PORT'))


if __name__ == '__main__':
    main()
