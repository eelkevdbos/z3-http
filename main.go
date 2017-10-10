package main

import (
	"net/http"
	"os/exec"
	"io"
	"os"
	"strings"
)

func main() {

	mux := http.NewServeMux()

	//split z3 arguments on comma
	args := strings.Split(os.Getenv("Z3_ARGS"),",")

	mux.HandleFunc("/", cors(func(w http.ResponseWriter, r *http.Request) {
		// Setup z3 command with -smt2 and -in args
		z3 := exec.Command("z3", args...)

		in, _ := z3.StdinPipe()
		out, _ := z3.StdoutPipe()
		defer out.Close()

		if err := z3.Start(); err != nil {
			http.Error(w, err.Error(), 500)
		}

		// Read request body to z3 stdin
		io.Copy(in, r.Body)

		// Close z3 stdin and copy stdout
		in.Close()
		io.Copy(w, out)

		if err := z3.Wait(); err != nil {
			http.Error(w, err.Error(), 500)
		}
	}))

	http.ListenAndServe(":80", mux)

}

// Cors wrapper to add access control headers
// And skip handling of option preflight
func cors(fn http.HandlerFunc) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		// Allow access from all origins
		if origin := r.Header.Get("Origin"); origin != "" {
			w.Header().Set("Access-Control-Allow-Origin", origin)
		}
		// Set default cors headers
		w.Header().Set("Access-Control-Allow-Methods", "POST, GET, OPTIONS, PUT, DELETE")
		w.Header().Set("Access-Control-Allow-Headers", "Content-Type, Content-Length, Accept-Encoding")
		w.Header().Set("Access-Control-Allow-Credentials", "true")
		// Only propagate handler when no preflight
		if r.Method != "OPTIONS" {
			fn(w, r)
		}
	}
}
