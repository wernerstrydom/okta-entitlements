# Okta Terraform 

Given a few applications, this repository demonstrates how to use terraform
to automate Okta, so that when an Okta user is created, they are granted the
appropiate access to applications without any further actions.  Furthermore 
the repository demonstrates how to do this using Jenkins, thus allowing 
more folks to contribute, maintain and review changes, without the Okta
administrator being the bottleneck.

Organizations consist of teams, and folks perform specific duties. This
*implies* that they are entitled to have access based on the duties they
perform, or the team they are part of. Sometimes that may also include 
the type of employment. 

## Requirements

Setting up applications and their roles can be a complicated affair, and
often relies on manual activities after created in Okta. In order to run
this module, you'll probably want to run the module to create the 
applications.

## Design

This repository assumes the following:

1. Applications already exists. We'll assume *GitHub*, *Salesforce*, and 
   *Google Workspaces*. 
2. Groups exist to represent Application Roles, e.g. *GitHub Users*, 
   *GitHub Owners*, *GitHub Developers* and so forth. It is recommended that
   the group names follow some naming convention, such as *AppRole - App - Role* (for example
   *AppRole - GitHub - Users*), so they are easily parsable by a machine.
3. Groups representing application roles are assigned to their respective
   applications and have the appropiate permissions.

Okta doesn't natively support a concepts of parties and relationships
between them. To bridge that gap, we'll create groups to represent the teams
within an organization. In order to ensure we can later parse them, we'll
follow a naming convention *Department - Name* where *Name* is the team 
name. 

We'll apply the same approach to defining groups for *job titles*, 
*user types* and whatnot.

### Pattern

You may see a pattern here: department, title and user type are all profile
fields in Okta. Some profile fields (assuming they are correct), have a 
direct implication to whether folks can have access to applications, 
services and other systems. 

So if location was of interest when it comes to having access, we could 
create groups for each location where the business resides, for example 
*Location - United States* and *Location - Ireland*. We can now 
assign folks access based on their location, thus allowing say employees in
the United States to access Amazon Web Services in the US, while folks in 
Ireland can access Amazon Web Services in Europe.  

## Contribution

This was a demonstration of how to use Terraform to automate Okta. 
Contributions are welcomed, even if it requires tailoring to be useful
for any organization.

## Jenkins

If you don't have a Jenkins server to test this out on, it's all good. Make
sure you have Docker and Docker Compose installed for your operating system.

You should be able to fire up a Jenkins server as follows:

```
docker-compose up
```

Once done, you'll need to add some secrets:

- okta-api-token
- okta-base-url
- okta-org-name
- aws-secret-key-id
- aws-secret-access-key
- terraform-backend-s3-bucket
- terraform-backend-s3-region
- terraform-backend-s3-dynamodb-table

You'll also need to configure Jenkins to access the git repository where you
forked this code.

```
Folders Plugin OWASP Markup Formatter Build Timeout Credentials Binding Plugin Timestamper Workspace Cleanup Ant Gradle Pipeline GitHub Branch Source Plugin Pipeline: GitHub Groovy Libraries Pipeline: Stage View Git plugin SSH Build Agents Matrix Authorization Strategy PAM Authentication LDAP Email Extension Mailer Plugin
```