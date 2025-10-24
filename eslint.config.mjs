import eslint from "@eslint/js";
import prettier from "eslint-config-prettier";
import importPlugin from "eslint-plugin-import";
import tseslint from "typescript-eslint";

export default tseslint.config(
    // --- base + TS recommended
    eslint.configs.recommended,
    ...tseslint.configs.recommended,
    prettier,

    // --- TypeScript source files
    {
        files: ["src/**/*.ts"],
        languageOptions: {
            parser: tseslint.parser,
            parserOptions: {
                project: "./tsconfig.json",
                sourceType: "module",
                ecmaVersion: 2022,
            },
        },
        plugins: { import: importPlugin },
        rules: {
            "no-console": "warn",
            eqeqeq: "error",
            "@typescript-eslint/no-unused-vars": ["warn", { argsIgnorePattern: "^_" }],
            "import/order": [
                "warn",
                {
                    alphabetize: { order: "asc", caseInsensitive: true },
                    "newlines-between": "always",
                },
            ],
        },
    },

    // --- JS/MJS build or config scripts (optional)
    {
        files: ["*.js", "*.mjs", "scripts/**/*.mjs"],
        languageOptions: {
            sourceType: "module",
            ecmaVersion: 2022,
        },
        plugins: { import: importPlugin },
        rules: {
            eqeqeq: "error",
            "import/order": [
                "warn",
                {
                    alphabetize: { order: "asc", caseInsensitive: true },
                    "newlines-between": "always",
                },
            ],
        },
    },

    // --- Global ignores (applies to everything)
    {
        ignores: [
            "dist/**",
            "node_modules/**",
            "infra/**",          // Terraform
            "lambda.zip",
            "*.log",
        ],
    }
);