# qml-cfg-autoform
Generate UI forms using yaml for schema and cfg json file for values of configuration.

# Usage
1. you only need to import the module in your project.
```
import "./config"
Config {
}
```
2. In the backend set properties:         
```
set_context_prop_func("cfg", config.yaml)
set_context_prop_func("cfgForm", config_schema.yaml)
```

### Run test
A python test is already provided you can install required packages in `test/req.txt` and run using `python main.py`
