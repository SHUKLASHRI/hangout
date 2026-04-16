# HANGOUT Handbook 🥂✨

Welcome to the official developer handbook for HANGOUT. This guide will walk you through setting up your machine, downloading the project, and the standard workflow for contributing code.

---

## 🛠️ 1. Environment Setup

### **A. Git (Version Control)**
1. **Download**: [git-scm.com](https://git-scm.com/downloads)
2. **Install**: Run the installer and keep the default settings.
3. **Configure**: Open your terminal (PowerShell or CMD) and run:
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```

### **B. Flutter SDK**
1. **Download**: [flutter.dev](https://docs.flutter.dev/get-started/install/windows)
2. **Extraction**: Extract the zip file to a folder like `C:\src\flutter`.
3. **Internal Path**: Add the `flutter\bin` folder to your system's "Environment Variables" (Path).
4. **Verify**: Open a terminal and run:
   ```bash
   flutter doctor
   ```
   *Follow any instructions it gives you to fix missing dependencies.*

### **C. Firebase CLI**
1. **Required**: Node.js must be installed ([nodejs.org](https://nodejs.org/)).
2. **Install CLI**: Run this in your terminal:
   ```bash
   npm install -g firebase-tools
   ```
3. **Login**: Authenticate with your Firebase account:
   ```bash
   firebase login
   ```

---

## 📥 2. How to Download the Project

To get the code onto your local machine for the first time:

1. Create a folder where you want the project to live.
2. Open a terminal in that folder.
3. Run the **Clone** command:
   ```bash
   git clone https://github.com/SHUKLASHRI/hangout.git
   ```
4. Move into the project directory:
   ```bash
   cd hangout
   ```
5. Install Flutter dependencies:
   ```bash
   flutter pub get
   ```

---

## 🔄 3. Daily Workflow (Syncing)

### **📥 Download Latest Changes (Pull)**
Before you start any new work, always make sure you have the latest code from the team:
```bash
git pull origin master
```

---

## 📤 4. How to Upload Your Work (Git)

Follow these steps to safely upload your code to the repository.

### **Step 1: Create a Feature Branch**
Never work directly on the `master` branch.
```bash
git checkout -b feature/your-feature-name
```

### **Step 2: Save Your Changes (Add & Commit)**
Once you've written some code:
```bash
# 1. See what files you changed
git status

# 2. Add all changes to be saved
git add .

# 3. Create a save point with a message
git commit -m "Added a beautiful new login screen"
```

### **Step 3: Upload to GitHub (Push)**
```bash
git push origin feature/your-feature-name
```
*After pushing, go to GitHub to create a Pull Request (PR).*

---

## 🚀 5. How to Deploy (Upload to Hosting)

If you are a Lead or have permission to deploy the live web app:

1. **Build for Web**:
   ```bash
   flutter build web --release
   ```
2. **Deploy to Firebase**:
   ```bash
   firebase deploy --only hosting
   ```
   *Note: Our CI/CD pipeline automatically does this when code is merged into `master`!*

---

## 💡 Quick Cheat Sheet

| Action | Command |
| :--- | :--- |
| **Download Project** | `git clone [url]` |
| **Install Packages** | `flutter pub get` |
| **Run App (Web)** | `flutter run -d chrome` |
| **Get Newest Code** | `git pull origin master` |
| **Save Code** | `git commit -am "message"` |
| **Upload Code** | `git push origin [branch]` |
| **Deploy App** | `firebase deploy` |

---

> [!TIP]
> Always run `flutter format .` before you commit to keep the code clean!
