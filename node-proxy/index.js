const {launch} = require('sia.js')
const httpProxy = require('http-proxy')
const commandLineArgs = require('command-line-args')

let siadProcess;
const options = commandLineArgs([
    { name: 'agent', type: String },
    { name: 'modules', alias: 'M', type: String, defaultValue: 'cgtw' },
    { name: 'no-bootstrap', type: Boolean },
    { name: 'profile', type: Boolean },
    { name: 'profile-directory', type: String, defaultValue: 'profiles' }
])

try {
    console.log('Starting siad process...');

    siadProcess = launch('/usr/bin/siad', Object.assign({}, options, {
        'sia-directory': '/siad/data',
        'api-addr': 'localhost:8880',
        'host-addr': ':8882',
        'rpc-addr': ':8881'
    }))

    console.log(`Done. PID: ${siadProcess.pid}`)

    siadProcess.on('error', err => {
        console.log(`siad encountered an error ${err}`)
    })
} catch (e) {
    console.error('error launching siad: ' + e.toString())
    process.exit(1)
}

process.on('SIGTERM', () => {
    console.log('Trying to stop siad...')
    siadProcess.kill()
})

process.on('SIGINT', () => {
    console.log('Trying to stop siad...')
    siadProcess.kill()

    setTimeout(() => process.exit(0), 30 * 1000)
})

const startProxy = (fromPort, toPort) => {
    httpProxy.createProxyServer({ target: `http://localhost:${toPort}` })
        .listen(fromPort)

    console.log(`Proxy started. Redirecting 0.0.0.0:${fromPort} -> :${toPort}`)
}

startProxy(9980, 8880)
startProxy(9981, 8881)
startProxy(9982, 8882)
