import sys
from PySide2.QtCore import QObject, Slot
from PySide2.QtWidgets import QApplication
from PySide2.QtQml import QQmlApplicationEngine
import qasync # This has to be after PySide2 import
import resources_rc
import json
import yaml

CONFIG_DIR = 'config.yaml'
CONFIG_SCHEMA_DIR = 'config_schema.yaml'

def get_cfg_form():
    form_cfg = open(CONFIG_SCHEMA_DIR, 'r').read()
    form_cfg = form_cfg.replace('\'', '"').replace('True', 'true')
    return json.loads(form_cfg)

def get_cfg():
    with open(CONFIG_DIR, 'r') as stream:
        try:
            return yaml.safe_load(stream)
        except yaml.YAMLError as exc:
            print(exc)

def write_yaml(yaml_dir, new_cfg):
    with open(yaml_dir, 'w') as outfile:
        yaml.dump(new_cfg, outfile, default_flow_style=False)

def write_cfg(new_cfg):
    global cfg
    try:
        write_yaml(CONFIG_DIR, new_cfg)
        cfg = new_cfg
    except Exception as e:
        write_yaml(CONFIG_DIR, cfg)
        return str(e)
    return ''

class Gui(QObject):

    def __init__(self):
        QObject.__init__(self)
        self.app = QApplication(sys.argv)
        self.app.setOrganizationName("Canopus")
        self.app.setOrganizationDomain("Artificial intelligence")
        self.engine = QQmlApplicationEngine()
        self.loop = qasync.QEventLoop(self.app)
        set_context_prop_func = self.engine.rootContext().setContextProperty
        self.set_context_prop_func = set_context_prop_func
        set_context_prop_func("backend", self)
        set_context_prop_func("cfg", get_cfg())
        set_context_prop_func("cfgForm", get_cfg_form())

    def start(self):
        # app.setWindowIcon(QIcon("images/icon.ico"))
        self.engine.load("../config/Config.qml")
        # Browser window start
        if self.app is not None:
            print("Endless wait for GUI")
            self.loop.run_forever()
        return self.app


    @Slot('QVariant', result=str)
    def saveConfig(self, new_cfg):
        new_cfg = new_cfg.toVariant()
        ret = write_cfg(new_cfg)
        self.set_context_prop_func('cfg', new_cfg)
        self.t = None
        return ret

if __name__ == "__main__":
    print("Setting up logger")
    guiObj = Gui()
    app = guiObj.start()
    loop = qasync.QEventLoop(app)
    if app is not None:
        print("Endless wait for GUI")
        loop.run_forever()
