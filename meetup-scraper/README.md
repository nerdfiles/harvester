# Workflow

## Step 1

Use ``$ node scrape-find.js`` or even ``$ node scrape-find.js > {{group-type}}.list`` 
to load up a list of group names. All you really need is the ``@href``.

## Step 2

Use ``$ node scrap-messages.js {{normalizedHref}} {{pageNum}}``.

## Step (TODO)

Review ``cron.coffee``.
