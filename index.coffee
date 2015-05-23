PythonShell = require('python-shell')

options =
  mode: 'text',
  pythonPath: '.'
  pythonOptions: ['-u']
  scriptPath: '../app/scripts'
  args: ['@user', '@user']


###
Run ChangeTip bots to check for new tips
###
PythonShell.run('__init__.py', options, (err, results) ->
  if err
    throw err
  console.log('results: %j', results)
)
