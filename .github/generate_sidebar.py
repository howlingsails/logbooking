import os
import json

DOCS_DIR = "website/docs"
SIDEBAR_FILE = "website/sidebars.js"

def generate_sidebar():
    sidebar_structure = {"docs": []}

    for root, dirs, files in os.walk(DOCS_DIR):
        if root == DOCS_DIR:
            continue  # Skip the root directory

        category = os.path.relpath(root, DOCS_DIR).replace(os.sep, "/")
        md_files = [f for f in files if f.endswith(".md")]

        if md_files:
            sidebar_structure["docs"].append({
                "type": "category",
                "label": category.capitalize().replace("-", " "),
                "items": [os.path.join(category, f).replace(".md", "") for f in md_files],
            })

    with open(SIDEBAR_FILE, "w") as f:
        f.write("module.exports = " + json.dumps(sidebar_structure, indent=2) + ";")

if __name__ == "__main__":
    generate_sidebar()
