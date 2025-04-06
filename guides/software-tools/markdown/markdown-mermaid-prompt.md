# 🧭 **Prompt Engineer’s Guide to Clean Mermaid Diagrams**

### 🎯 **Mission Objective:**
Train ChatGPT to always generate Mermaid diagrams that are:
- **Semantically accurate**
- **Markdown-safe**
- **Environment-compatible**
- **Escaped, styled, and readable**

---

## ⚙️ **Universal Prompt Framework**

When requesting a Mermaid diagram, **prepend your prompt with this setup**:

> “Act as an expert Mermaid diagram formatter and prompt engineer. Ensure the diagram uses proper formatting, styling, and character escaping across all environments (Live Editor, VS Code, GitHub). Use markdown where supported (bold, italic), escape special characters (like `<`, `>`, `&`), and use aliases/quotes when node names or labels contain spaces, symbols, or keywords.”

Then follow with your intent.

---

## 🧱 **Structural Prompt Format**

Use this skeleton for any request:

```
Create a Mermaid <diagram-type> showing <summary of logic>.

Requirements:
- Use Markdown formatting for labels (**bold**, *italic*) only if supported by this diagram type.
- Escape all special characters (`<`, `>`, `&`, `"`) using HTML entities or backticks.
- Quote all labels or node names with spaces or reserved words.
- For flowcharts, wrap labels in Markdown string syntax (e.g., `["`**bold** text`"]`).
- Avoid unsupported formatting in diagrams like Sequence, Journey, or Pie.
- Use aliases for nodes/entities with special characters or display labels.
- Line breaks should use `\n` or quoted markdown where supported.

Output only the Mermaid code block, with no extra commentary.
```

---

## 🔍 **Diagram-Type Smart Defaults**

| Diagram Type       | Supports Markdown? | Special Notes |
|--------------------|---------------------|----------------|
| **Flowchart**       | ✅ **(v10.1+)**        | Use backtick-wrapped markdown strings. Use `["`text`"]`. Escape: `&lt;` `&gt;` `&quot;`. |
| **Sequence**        | ❌ No                 | No markdown support. Use `\n` for line breaks. Escape colons and semicolons (`&#58;`, `&#59;`). |
| **Class**           | ❌ No                 | No inline formatting. Use aliasing for labels. Escape angle brackets in labels. |
| **State**           | ❌ No                 | Use `classDef` for styling entire nodes. Escape characters in quoted aliases. |
| **Gantt**           | ❌ No                 | Avoid colons/semicolons in labels. No formatting allowed. No `\n`. |
| **Entity Relationship** | ✅ Yes             | Markdown allowed in comments and display labels. Quote all text fields. |
| **Requirement**     | ✅ Yes               | Use quoted strings for formatting. Only `text`, `docref`, and `description` support markdown. |
| **Pie**             | ❌ No                 | Labels are literal. Escape quotes and angle brackets with entities. |
| **Journey**         | ❌ No                 | No styling allowed. Escape colons carefully. Emojis supported. |

---

## 📐 **Best Practices**

### ✅ Use markdown smartly (only where supported)
```
nodeA["`**Main Node**`"]
```

### ✅ Escape problematic characters
```
nodeB["Input &lt;= 100 &amp;&gt; 10"]
```

### ✅ Alias for nodes with complex labels
```
class DataFlow as "Data & Control Flow"
```

### ✅ Define styles with `classDef` (e.g., for states)
```
classDef important fill:#f00,color:#fff;
class Danger important
```

### ✅ Safe formatting + line break
```
note right of A: This is a long note\nwith a line break
```

---

## ❌ **What to Avoid**

- ❌ Unescaped `<`, `>`, `&`, or `"`.
- ❌ Using `**bold**` or `<b>` in diagrams that don’t support formatting.
- ❌ Inserting colons (`:`) in labels for Gantt or Journey without escaping.
- ❌ Forgetting that `end`, `state`, and `class` are **reserved words** in some diagrams.
- ❌ Using line breaks (`\n`) where not supported (e.g., Gantt, Pie).

---

## 🚨 Example: Bulletproof Prompt

> **"Create a Mermaid flowchart showing a login process. Include nodes with bold and italic labels, escape special characters, and use quotes for any labels with spaces. Render all labels using backtick-wrapped markdown strings and HTML entities where needed."**

---

## 🧭 Final Tactic: Use Prompt Tags for Diagrams

When scaling, consider prompt tagging for automation:

```
[MERMAID][FLOWCHART][SAFE][MARKDOWN]
Generate a flowchart showing database replication. Use markdown strings in node labels and escape HTML-sensitive characters.
```

---

Would you like me to bundle this guide into a Markdown file you can reuse across projects, with copy-ready templates?