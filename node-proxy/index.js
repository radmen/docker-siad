const express = require('express')
const proxy = require('express-http-proxy')
const {launch} = require('sia.js')

let siadProcess;

try {
    console.log('Starting siad process...');

    siadProcess = launch('/usr/bin/siad', {
        'modules': 'cgtw',
        'sia-directory': '/siad/data'
    })

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

const app = express()
app.use('/', proxy('localhost:9980'))
app.listen(80)

console.log('Proxy started.. listening on localhost:80')
