package main

import (
	"context"
	"fmt"
	"strings"

	"github.com/docker/docker/api/types"
	"github.com/docker/docker/api/types/container"
	"github.com/docker/docker/api/types/filters"
	"github.com/docker/docker/client"
)

const (
	helperLabelRulePrefix    = "rules"
	helperLabelDomainPostfix = "domain"
	helperLabelEmailPostfix  = "email"
)

type rule struct {
	name      string
	container types.Container
}

func listMatchedRules(ctx context.Context, cli *client.Client, domain, email string) ([]rule, error) {
	containers, err := cli.ContainerList(ctx, container.ListOptions{
		All: false,
		Filters: filters.NewArgs(
			filters.Arg("label", fmt.Sprintf("%s.enable=true", helperLabelPrefix)),
		),
	})
	if err != nil {
		return nil, err
	}

	return filter(containers, domain, email), nil
}

// filter containers.
// If the rule's domain matched and email is not specified or also matched, keep it.
func filter(containers []types.Container, domain, email string) (rules []rule) {
	for _, c := range containers {
		for k, v := range c.Labels {
			parts := strings.Split(k, ".")
			if len(parts) == 4 &&
				parts[0] == helperLabelPrefix &&
				parts[1] == helperLabelRulePrefix &&
				parts[3] == helperLabelDomainPostfix &&
				v == domain {
				v2, exist := c.Labels[fmt.Sprintf("%s.%s.%s.%s", helperLabelPrefix, helperLabelRulePrefix, parts[2], helperLabelEmailPostfix)]
				if !exist || v2 == email {
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
