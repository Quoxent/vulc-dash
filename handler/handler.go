package handler

import (
	"github.com/gin-gonic/gin"
	"github.com/vulcanocrypto/vulc-dash/data"
)

// GetNodeInfo will return all the information
// needed to be displayed on the dashboard.
func GetNodeInfo(c *gin.Context) {
	// Get database.
	db := c.MustGet("db").(*data.DB)

	// Pull last entry and return.
	info, err := db.Last()
	if err != nil {
		c.Error(err)
		return
	}

	// Return as json to client.
	c.JSON(200, info)
}
