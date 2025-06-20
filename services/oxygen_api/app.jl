using Oxygen
using HTTP

@get "/hello" function(req::HTTP.Request)
    return Oxygen.json("Oxygen (Julia) says hi!")
end

Oxygen.serve(port=8000, host="0.0.0.0")
