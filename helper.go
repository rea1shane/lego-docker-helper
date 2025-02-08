package main

import (
	"fmt"
	"os"

	"github.com/docker/docker/client"
)

const (
	helperLabelPrefix = "lego-helper"
)

// Environment variables provided by Lego
// https://go-acme.github.io/lego/usage/cli/obtain-a-certificate/index.html
var (
	legoAccountEmail = os.Getenv("LEGO_ACCOUNT_EMAIL")
	legoCertDomain   = os.Getenv("LEGO_CERT_DOMAIN")
	legoCertPath     = os.Getenv("LEGO_CERT_PATH")
	legoCertKeyPath  = os.Getenv("LEGO_CERT_KEY_PATH")
	legoCertPemPath  = os.Getenv("LEGO_CERT_PEM_PATH")
	legoCertPfxPath  = os.Getenv("LEGO_CERT_PFX_PATH")
)

func main() {
	cli, err := client.NewClientWithOpts(client.FromEnv)
	if err != nil {
		panic(fmt.Errorf("failed to create docker client: %v", err))
	}
	defer cli.Close()
}
