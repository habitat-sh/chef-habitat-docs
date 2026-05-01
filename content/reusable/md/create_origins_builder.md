
To create an origin in Chef Habitat Builder, follow these steps:

1. In Habitat Builder, select **My Origins** in the left navigation menu.

1. On the **My Origins** page, select **Create origin** to open the **Create New Origin** form.

1. Enter a unique name that you want to associate with your packages. Chef Habitat only allows you to create an origin with a unique name. Some examples you'll see in Chef Habitat Builder are team names, user names, and abstract concepts.

1. Choose a privacy setting to use as the default for new packages. You can override this setting when uploading individual packages from the CLI or by using a plan file that declares a package as private.

   The difference between public and private packages is:

   - Anyone can find and use public packages.
   - Only users with origin membership can find and use private packages.

1. Select **Save and Continue**.

    Habitat Builder does the following:

    - Creates your origin.
    - Creates an [origin key pair](/origins/origin_keys).
    - Redirects Chef Habitat Builder to the origin page.

   ![Origin successfully created](/images/habitat/create-origin-done.png)
