package main

import (
    "net/http"
    "github.com/gin-gonic/gin"
)

func getHello(c *gin.Context) {
    c.IndentedJSON(http.StatusOK, "Gin (Go) says hi!")
}

func main() {
    router := gin.Default()
    router.GET("/hello", getHello)

    router.Run("0.0.0.0:8000")
}
