import yaml

with open('config.yaml') as settings:
    cfg = yaml.load(settings)

variable_name = cfg['config_name']