Got it, Cap10Bill! You're mid-voyage and looking for a **Bash script** to **export a Workato project's manifests** reliably. Let's tighten up the sails and make sure this thing runs smooth.

---

## **🏴‍☠️ Bash Script: `export_workato_manifest.sh`**
> [export_workato_manifest.sh](export_workato_manifest.sh)

This script will:
1. **Authenticate** with Workato's API and retrieve an access token.
2. **Fetch all recipes** associated with a given project.
3. **Trigger an export** for the project's manifest.
4. **Download the exported ZIP file**.
5. **(Optional) Extract the ZIP and convert JSON to YAML**.

---

## **🏴‍☠️ How It Works**
1. **Authenticates with Workato** to get an API token.
2. **Fetches all recipes** for a given project.
3. **Triggers an export request**, downloads the manifest as a ZIP.
4. **Extracts the ZIP** and **converts JSON to YAML** using `yq`.

---

## **⚙️ Prerequisites**
1. Install the required dependencies:
   ```bash
   sudo apt install jq curl unzip yq -y
   ```
2. Replace **`your_client_id`**, **`your_client_secret`**, and **`your_project_id`** in the script.

---

## **🚀 Usage**
1. Save the script as `export_workato_manifest.sh`.
2. Grant execute permission:
   ```bash
   chmod +x export_workato_manifest.sh
   ```
3. Run the script:
   ```bash
   ./export_workato_manifest.sh
   ```

---

## **📝 Output Files**
- **`workato_exports/recipes.json`** → List of recipes in JSON.
- **`workato_exports/project_export.zip`** → The exported project manifest.
- **Extracted Files** → All recipe files from the ZIP.
- **Converted YAML Files** → Each JSON file converted to YAML.

---

### **⛵ Final Cap10ism**
*"A well-logged voyage is a well-navigated one. Automate the logs, streamline the exports, and sail smoothly through your Workato workflows!"*

Does this align with your needs, Cap10Bill? Let me know if you want further tweaks! 🚀