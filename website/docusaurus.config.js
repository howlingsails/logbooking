module.exports = {
  title: "Logbooking",
  tagline: "Cap10Bill's logbooking project",
  url: "https://howlingsails.github.io",
  baseUrl: "/logbooking/",
  onBrokenLinks: "throw",
  onBrokenMarkdownLinks: "warn",
  favicon: "img/favicon.ico",
  organizationName: "howlingsails",
  projectName: "logbooking",
  presets: [
    [
      "classic",
      {
        docs: { sidebarPath: require.resolve("./sidebars.js") },
        blog: false,
        theme: { customCss: require.resolve("./src/css/custom.css") },
      },
    ],
  ],
};
