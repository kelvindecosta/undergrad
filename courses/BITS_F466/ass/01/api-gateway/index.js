const express = require('express')
const axios = require('axios')
const cors = require('cors')
const app = express()

// Use CORS to prevent Cross-Origin Requets issue
app.use(cors())

const CODE_2_COUNTRY_API = process.env.CODE_2_COUNTRY_API
const COUNTRY_2_CODE_API = process.env.COUNTRY_2_CODE_API

// Get the status of the API
app.get('/api/status', (req, res) => {
    return res.json({status: 'ok'})
})

// Code to Country
app.get('/api/country/:code',async (req, res) => {
    try {
        const url = CODE_2_COUNTRY_API + '/api/' + req.params.code
        const result = await axios.get(url)
        return res.json({
            time: Date.now(),
            country: result.data.country
        })
    } catch (error) {
        console.log(error)
        res.status(500)
        return res.json({
            message: "Internal server error",
        })
    }

})

// Code to Country
app.get('/api/code/:country',async (req, res) => {
    try {
        const url = COUNTRY_2_CODE_API + '/api/' + req.params.country
        const result = await axios.get(url)
        return res.json({
            time: Date.now(),
            code: result.data.code
        })
    } catch (error) {
        console.log(error)
        res.status(500)
        return res.json({
            message: "Internal server error",
        })
    }

})

// Handle any unknown route
app.get('*', (req, res) => {
    res.status(404)
    return res.json({
        message: 'Resource not found'
    })
});

// starts the app
app.listen(3000, () => {
    console.log('API Gateway is listening on port 3000!')
})
