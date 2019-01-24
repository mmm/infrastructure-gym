package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"os/exec"
)

func doSomeWork() {

	threads := os.Getenv("HEATER_THREADS")
	if threads == "" {
		threads = "1"
	}
	timeout := os.Getenv("HEATER_TIMEOUT")
	if timeout == "" {
		timeout = "2"
	}

	cmd := exec.Command("stress", "--cpu", threads, "-v", "--timeout", timeout)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	if err := cmd.Run(); err != nil {
		log.Fatal("heater: exec error ", err)
	}
}

func generateHeat(w http.ResponseWriter, r *http.Request) {

	remote := r.RemoteAddr
	if r.Header.Get("X-FORWARDED-FOR") != "" {
		remote = r.Header.Get("X-FORWARDED-FOR")
	}

	log.Printf("heater: handling request %s from %s", r.URL.Path, remote)
	doSomeWork()
	log.Printf("heater: done with request %s from %s", r.URL.Path, remote)

	hostname, err := os.Hostname()
	if err != nil {
		log.Fatal("heater: Hostname error ", err)
	}
	fmt.Fprintf(w, "Hello %s from %s\n", remote, hostname)
}

func main() {

	heaterPort := os.Getenv("HEATER_PORT")
	if heaterPort == "" {
		heaterPort = "80"
	}

	http.HandleFunc("/", generateHeat)

	log.Printf("heater: started service listening on port: %s", heaterPort)
	err := http.ListenAndServe(":"+heaterPort, nil)
	if err != nil {
		log.Fatal("heater: ListenAndServer error ", err)
	}
}
