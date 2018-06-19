// Handlers for the website, yafeel?
package main

import (
	"fmt"
	"net/http"

	"google.golang.org/appengine"
)

func indexHandler(w http.ResponseWriter, r *http.Request) {
	if r.URL.Path != "/" {
		http.Redirect(w, r, "/", http.StatusFound)
		return
	}
	fmt.Fprintln(w, "Photography website under construction")
}

func main() {
	http.HandleFunc("/", indexHandler)
	appengine.Main()
}
