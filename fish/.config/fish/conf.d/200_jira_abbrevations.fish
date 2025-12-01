
# Sprint
abbr jcslf jira sprint list --current -q "statusCategory != Done AND assignee = $JIRA_SANITIZED_UER_EMAIL"
abbr jcsl jira sprint list --current 

# Epic
abbr jcelf jira epic list -q "statusCategory != Done"
abbr jcel jira epic list
