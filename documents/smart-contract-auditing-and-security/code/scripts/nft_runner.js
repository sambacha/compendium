const { exec } = require('child_process')
const fs = require('fs-extra')
const newman_string = getPath(3) + 'node_modules/.bin/newman run ' + getPath(3) + 'tests/integration_test/postman/BlockArrayIntegrationTests.postman_collection.json --folder ' 

function getPath(directories_to_strip) {
  var path = __dirname
  var arr = __dirname.split('/')
  arr = arr.slice(0, arr.length - directories_to_strip)
  return arr.join('/') + '/'
}

module.exports = (script_name, callback) => {
  let script_output = getPath(1) + '/logs/' + script_name + '_output'
  let script_error = getPath(1) + '/logs/' + script_name + '_error'
  exec(newman_string + script_name + ' -d ' + getPath(3) + 'tests/integration_test/postman/nft_integration_data.csv', (stderr, stdout) => {
    fs.writeFile(script_error, stderr, (error) => {
      if (error) callback(error) 
      fs.writeFile(script_output, stdout, (err) => {
        if (err) callback(error) 
        callback()
      })
    })
  })
}
