package rule

import (
	"fmt"
	"strings"

	"github.com/docker/docker/api/types"
)

const (
	labelRulePrefix        = "rules"
	labelDomainSuffix      = "domain"
	labelEmailSuffix       = "email"
	labelDestinationSuffix = "destination"
)

func ListMatchedRules(containers []types.Container, labelPrefix, domain, email string) (rules []rule) {
	for _, c := range containers {
		for k, v := range c.Labels {
			parts := strings.Split(k, ".")
			if len(parts) == 4 &&
				parts[0] == labelPrefix &&
				parts[1] == labelRulePrefix &&
				parts[3] == labelDomainSuffix &&
				v == domain {
				emailValue, exist := c.Labels[fmt.Sprintf("%s.%s.%s.%s", labelPrefix, labelRulePrefix, parts[2], labelEmailSuffix)]
				if !exist || emailValue == email {
					rules = append(rules, rule{
						name:      parts[2],
						container: c,
					})
				}
			}
		}
	}
	return
}

type rule struct {
	name      string
	container types.Container
}

func (r *rule) Exec() error {
	r.copy()
	r.action()
}

func (r *rule) copy() error {

}

func (r *rule) action() error {

}
