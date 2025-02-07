package lego

import (
	"os"
)

// EnvVars provided by Lego
// https://go-acme.github.io/lego/usage/cli/obtain-a-certificate/index.html
type EnvVars struct {
	AccountEmail string
	CertDomain   string
	CertPath     string
	CertKeyPath  string
	CertPemPath  string
	CertPfxPath  string
}

func GetEnvVars() EnvVars {
	return EnvVars{
		AccountEmail: os.Getenv("LEGO_ACCOUNT_EMAIL"),
		CertDomain:   os.Getenv("LEGO_CERT_DOMAIN"),
		CertPath:     os.Getenv("LEGO_CERT_PATH"),
		CertKeyPath:  os.Getenv("LEGO_CERT_KEY_PATH"),
		CertPemPath:  os.Getenv("LEGO_CERT_PEM_PATH"),
		CertPfxPath:  os.Getenv("LEGO_CERT_PFX_PATH"),
	}
}
