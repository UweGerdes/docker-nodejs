npmis() {
    pwd="$(pwd)"
    cp "${APP_HOME}/package.json" "${NODE_HOME}"
    cd "${NODE_HOME}"
    npm install --save $@
    cp "${APP_HOME}/package.json" "${NODE_HOME}"
    cd "${pwd}"
}

npmisd() {
    pwd="$(pwd)"
    cp "${APP_HOME}/package.json" "${NODE_HOME}"
    cd "${NODE_HOME}"
    npm install --save-dev $@
    cp "${APP_HOME}/package.json" "${NODE_HOME}"
    cd "${pwd}"
}

