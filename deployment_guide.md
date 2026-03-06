# Automated Deployment Guide (GitHub to Vercel)

Follow these exact steps to push your personal portfolio code to GitHub and deploy it for free to Vercel with your custom domain (`bogdanovskiy.com`).

## Step 1: Push Project to GitHub

1. Open your terminal in VS Code or Cursor. Make sure you are in the project folder (`/Users/db2414/Desktop/Personal WEB Page`).
2. Run the following commands to initialize a local Git repository and commit all files:
   ```bash
   git init
   git add .
   git commit -m "Initial commit of personal portfolio"
   ```
3. Open your browser and go to [GitHub](https://github.com/new) and log in.
4. Create a new repository named `personal-web-page` (or anything you prefer). Keep it Public or Private (Vercel supports both for Hobby plans). **Do not check** "Add a README file" or "Add .gitignore".
5. Copy the URL from the Quick Setup page. It will look like `https://github.com/pugging/personal-web-page.git`.
6. Go back to your terminal and run the commands provided by GitHub (replace the URL with yours):
   ```bash
   git branch -M main
   git remote add origin https://github.com/pugging/personal-web-page.git
   git push -u origin main
   ```
   _Note: It may prompt you to log into GitHub in the terminal._

## Step 2: Import Project on Vercel

1. Log in to [Vercel](https://vercel.com/login). You can log in with your GitHub account.
2. In your dashboard, click the **"Add New..."** button in the top right, then select **"Project"**.
3. Under "Import Git Repository", find your repository `personal-web-page` and click **"Import"**.
4. In the "Configure Project" step:
   - **Framework Preset**: Vercel should automatically detect **Vite**.
   - **Build Command**: Leave as `vite build` (or the default).
   - **Output Directory**: Leave as `dist` (or the default).
5. Click the **"Deploy"** button.
6. Wait 1–2 minutes for Vercel to build your project. You'll see a congratulations screen when it's finish! You can click the "Visit" button to see it on Vercel's `.vercel.app` subdomain.

## Step 3: Configure Custom Domain (bogdanovskiy.com) & Free HTTPS SSL

1. In the Vercel dashboard for your newly deployed project, click on **Settings** in the top navigation bar.
2. In the left sidebar, click **Domains**.
3. Type your domain: `bogdanovskiy.com` in the input field and click **Add**.
4. Vercel will ask if you want to add `www.bogdanovskiy.com` as well. Select the recommended option (redirecting `www` to the non-`www` domain or vice versa).
5. **DNS Configuration:** Vercel will now show you the DNS records you need to add to your domain registrar (where you bought `bogdanovskiy.com`, e.g., Namecheap, GoDaddy). It usually requires:
   - An **A Record** pointing to `76.76.21.21` (for `bogdanovskiy.com`).
   - A **CNAME Record** pointing to `cname.vercel-dns.com` (for `www.bogdanovskiy.com`).
6. Log into your domain registrar, go to DNS Settings, and add identically those records.
7. Go back to Vercel. Once the DNS records propagate (which can take a few minutes to a few hours), Vercel will verify the domain.
8. **HTTPS Verification:** Vercel will automatically generate a Let's Encrypt SSL certificate. You don't need to do anything. Within minutes, your site will be served securely over HTTPS!

If you encounter any issues during the build, make sure `Vite` is picking up the `ceilor` directory correctly! (If it fails, we can adjust the Rollup/Vite configuration).
