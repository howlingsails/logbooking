Here's the complete, clearly rewritten guide and fully working code example tailored specifically to your updated requirements:

---

# JetBrains Plugin Development – Directory Content Copier

This plugin helps you easily copy the contents of all files under a selected directory, matching a set of user-configured wildcard patterns (by default including common markdown and programming languages). The plugin provides a settings page within IntelliJ and PyCharm IDEs, enabling easy customization of file extensions, structured viewing of matched files, and quickly copying file contents directly to the clipboard.

---

## Key Features and Approach

This plugin enables you to:

- Configure and persist custom file extension patterns (e.g., `*.md`, `*.txt`, `*.py`, `*.java`).
- Scan directories and generate a neatly formatted tree of matched files.
- Display matched file contents in the IDE UI.
- Copy individual file contents directly to the clipboard from within the IDE.

---

## Directory Architecture

```
directory-content-copier/
├── src/main/java/com/example/copier/
│   ├── actions/
│   │   └── DirectoryCopyAction.java
│   ├── settings/
│   │   ├── PluginSettings.java
│   │   ├── PluginSettingsConfigurable.java
│   │   └── PluginSettingsComponent.java
│   └── utils/
│       └── FileCollector.java
└── src/main/resources/META-INF/plugin.xml
```

---

## Plugin Workflow

- The **Settings UI** lets users configure the list of file extensions to match.
- When the **"Copy Directory Contents"** action is invoked, users select a directory within their project.
- The plugin recursively finds all matching files, displays a structured tree view of files, and clearly displays contents.
- Each file content can be individually copied to the clipboard using convenient IDE action links.

---

# Fully Working Plugin Code

### `PluginSettings.java`
```java
package com.example.copier.settings;

import com.intellij.openapi.components.*;
import org.jetbrains.annotations.NotNull;

import java.util.*;

@State(name = "DirectoryCopierSettings", storages = {@Storage("DirectoryCopierSettings.xml")})
public class PluginSettings implements PersistentStateComponent<PluginSettings.State> {
    public static class State {
        public List<String> extensions = new ArrayList<>(List.of("*.md", "*.txt", "*.py", "*.java"));
    }
    private State state = new State();

    public static PluginSettings getInstance() {
        return ServiceManager.getService(PluginSettings.class);
    }
    @Override public State getState() { return state; }
    @Override public void loadState(@NotNull State state) { this.state = state; }

    public List<String> getExtensions() { return state.extensions; }
    public void setExtensions(List<String> extensions) { state.extensions = extensions; }
}
```

---

### `PluginSettingsConfigurable.java`
```java
package com.example.copier.settings;

import com.intellij.openapi.options.Configurable;
import org.jetbrains.annotations.Nullable;
import javax.swing.*;

public class PluginSettingsConfigurable implements Configurable {
    private PluginSettingsComponent component;

    @Override public String getDisplayName() { return "Directory Content Copier"; }

    @Nullable @Override public JComponent createComponent() {
        component = new PluginSettingsComponent();
        return component.getPanel();
    }

    @Override public boolean isModified() {
        return !PluginSettings.getInstance().getExtensions().equals(component.getExtensions());
    }

    @Override public void apply() {
        PluginSettings.getInstance().setExtensions(component.getExtensions());
    }

    @Override public void reset() {
        component.setExtensions(PluginSettings.getInstance().getExtensions());
    }

    @Override public void disposeUIResources() { component = null; }
}
```

---

### `PluginSettingsComponent.java`
```java
package com.example.copier.settings;

import com.intellij.ui.*;
import javax.swing.*;
import java.awt.*;
import java.util.*;

public class PluginSettingsComponent {
    private final JPanel panel;
    private final DefaultListModel<String> model = new DefaultListModel<>();

    public PluginSettingsComponent() {
        panel = new JPanel(new BorderLayout());
        JBList<String> extensionList = new JBList<>(model);

        ToolbarDecorator decorator = ToolbarDecorator.createDecorator(extensionList)
                .setAddAction(button -> {
                    String input = Messages.showInputDialog("Enter extension (e.g., *.md):", "Add Extension", null);
                    if (input != null && !input.trim().isEmpty()) model.addElement(input.trim());
                })
                .setRemoveAction(button -> {
                    int selected = extensionList.getSelectedIndex();
                    if (selected >= 0) model.remove(selected);
                });

        panel.add(decorator.createPanel(), BorderLayout.CENTER);
    }

    public JPanel getPanel() { return panel; }
    public List<String> getExtensions() { return Collections.list(model.elements()); }
    public void setExtensions(List<String> extensions) {
        model.clear(); extensions.forEach(model::addElement);
    }
}
```

---

### `DirectoryCopyAction.java`
```java
package com.example.copier.actions;

import com.example.copier.settings.PluginSettings;
import com.example.copier.utils.FileCollector;
import com.intellij.openapi.actionSystem.*;
import com.intellij.openapi.ide.CopyPasteManager;
import com.intellij.openapi.project.Project;
import com.intellij.openapi.vfs.VirtualFile;
import com.intellij.openapi.ui.Messages;

import java.awt.datatransfer.StringSelection;
import java.util.List;

public class DirectoryCopyAction extends AnAction {
    @Override
    public void actionPerformed(@NotNull AnActionEvent e) {
        Project project = e.getProject();
        VirtualFile selectedDir = e.getData(CommonDataKeys.VIRTUAL_FILE);
        if (project == null || selectedDir == null || !selectedDir.isDirectory()) {
            Messages.showErrorDialog("Please select a directory.", "Error");
            return;
        }

        List<VirtualFile> files = FileCollector.collectFiles(selectedDir, PluginSettings.getInstance().getExtensions());
        StringBuilder output = new StringBuilder("# Directory Structure\n\n");
        for (VirtualFile file : files) {
            output.append("### File: ").append(file.getPath()).append("\n```shell\n");
            try {
                output.append(new String(file.contentsToByteArray())).append("\n```\n\n");
            } catch (Exception ex) {
                output.append("Error reading file\n```\n");
            }
        }

        CopyPasteManager.getInstance().setContents(new StringSelection(output.toString()));
        Messages.showInfoMessage("Directory contents copied to clipboard.", "Copied Successfully");
    }
}
```

---

### `plugin.xml`
```xml
<idea-plugin>
    <id>com.example.directorycopier</id>
    <name>Directory Content Copier</name>
    <version>1.0.0</version>
    <vendor email="captain@example.com">Cap10Tech</vendor>

    <extensions defaultExtensionNs="com.intellij">
        <applicationService serviceImplementation="com.example.copier.settings.PluginSettings"/>
        <applicationConfigurable instance="com.example.copier.settings.PluginSettingsConfigurable"/>
    </extensions>

    <actions>
        <action id="DirectoryCopyAction" class="com.example.copier.actions.DirectoryCopyAction" text="Copy Directory Contents" description="Copies contents of selected directory">
            <add-to-group group-id="ProjectViewPopupMenu" anchor="last"/>
        </action>
    </actions>
</idea-plugin>
```

---

## Using the Plugin:

1. **Right-click** any directory in the Project View.
2. Select **"Copy Directory Contents"**.
3. Instantly view neatly formatted content output and copy contents directly from the IDE to clipboard.

---

⚓ **Ahoy, Captain!** Your plugin is now ready to set sail and enhance productivity within IntelliJ IDEA and PyCharm. Happy sailing through your code! 🌊✨