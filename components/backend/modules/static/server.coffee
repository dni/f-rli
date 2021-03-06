fs = require "fs-extra"
auth = require './../../utilities/auth'

module.exports.setup = (app, config)->

  StaticblockSchema = require('./../../lib/model/Schema')(config.dbTable)

  # Insert Frontend Layout Data
  StaticblockSchema.count {}, (err, count)->
    if count is 0
      spawn = require('child_process').spawn
      console.log "Imported Static Blocks"
      mongoimport = spawn 'mongoimport', ['--db', app.config.dbname, '--collection', 'staticblocks', '--file', 'staticblocks.json'], cwd:__dirname+'/data/'

  # export StaticBlock
  app.get '/exportStaticBlocks', auth, (req, res)->
    if fs.existsSync __dirname+'/data/staticblocks.json' then fs.unlinkSync __dirname+'/data/staticblocks.json'
    spawn = require('child_process').spawn
    mongoexport = spawn('mongoexport', ['-d', app.config.dbname, '-c', 'staticblocks', '-o', 'staticblocks.json'], cwd:__dirname+'/data/').on 'exit', (code)->
      if code is 0
        res.send("Exported Static Blocks")
        console.log("Exported Static Blocks")
      else
        res.send('Error: while exporting Static Blocks, code: ' + code)
        console.log('Error: while exporting Static Blocks, code: ' + code)
