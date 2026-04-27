return {
  "Civitasv/cmake-tools.nvim",
  keys = {
    { "<leader>cb", "<cmd>CMakeBuild<cr>", desc = "CMake Build" },
    { "<leader>cB", "<cmd>CMakeBuildCurrentFile<cr>", desc = "CMake Build Current File" },
    { "<leader>cx", "<cmd>CMakeRun<cr>", desc = "CMake Run Executable" },
    { "<leader>cX", "<cmd>CMakeRunCurrentFile<cr>", desc = "CMake Run Executable Current File" },
    { "<leader>cq", "<cmd>CMakeCloseRunner<cr>", desc = "CMake Close Runner" },
  },
}
