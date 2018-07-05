package matchers

import (
	"reflect"

	github "github.com/google/go-github/github"
	"github.com/petergtz/pegomock"
)

func AnyPtrToGithubPullRequestEvent() *github.PullRequestEvent {
	pegomock.RegisterMatcher(pegomock.NewAnyMatcher(reflect.TypeOf((*(*github.PullRequestEvent))(nil)).Elem()))
	var nullValue *github.PullRequestEvent
	return nullValue
}

func EqPtrToGithubPullRequestEvent(value *github.PullRequestEvent) *github.PullRequestEvent {
	pegomock.RegisterMatcher(&pegomock.EqMatcher{Value: value})
	var nullValue *github.PullRequestEvent
	return nullValue
}