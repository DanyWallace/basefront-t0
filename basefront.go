package main

import (
	"fmt"
	"log"
	"os"

	"github.com/pocketbase/pocketbase"
	"github.com/pocketbase/pocketbase/core"
)

func main() {
	app := pocketbase.New()

	app.OnRecordAuthRequest().Add(func(e *core.RecordAuthEvent) error {
		socketPath := "basecomms.sock"

		formatted_record := fmt.Sprintf("Login-Token: %v\nRecord: %v\n", e.Token, e.Record)
		// log.Println(e.Record)
		log.Println(formatted_record)
		err := writeToUnixSocket(socketPath, formatted_record)
		if err != nil {
			fmt.Fprintf(os.Stderr, "%v\n", err)
		}
		return nil
	})

	if err := app.Start(); err != nil {
		log.Fatal(err)
	}
}
