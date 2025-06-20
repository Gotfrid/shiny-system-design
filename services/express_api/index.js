const express = require('express')
const app = express()
const port = 8000

app.get('/hello', (req, res) => {
  res.json('Express (JavaScript) says hi!')
})

app.listen(port, () => {
  console.log(`Express app is up and running on port ${port}`)
})
