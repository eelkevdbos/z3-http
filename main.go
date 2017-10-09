package main

import (
	"net/http"
	"os/exec"
	"io"
)

func main() {

	m := http.NewServeMux()

	m.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {

		// Setup z3 command with -smt2 and -in args
		z3 := exec.Command("z3", "-smt2", "-in")

		in, err := z3.StdinPipe()

		out, err := z3.StdoutPipe()

		if err != nil {
			http.Error(w, err.Error(), 500)
		}

		z3.Start()

		// Read request body to stdin of z3 command
		io.Copy(in, r.Body)

		// Close z3 stdin and copy stdout
		in.Close()
		io.Copy(w, out)

		// Wait for z3 to exit
		z3.Wait()

	})

	http.ListenAndServe(":80", m)

}