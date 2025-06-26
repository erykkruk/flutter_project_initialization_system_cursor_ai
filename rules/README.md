# Flutter Clean Architecture Rules - Modular System

This directory contains modular Cursor rules for Flutter projects following Clean Architecture principles. Each file focuses on a specific aspect of development and uses the appropriate rule type for optimal integration.

## Rule Files Overview

### 🔧 Core Rules (Always Active)

- **`01_core_architecture.mdc`** - Fundamental Clean Architecture principles that apply to every conversation

### 🎯 Auto-Attached Rules (Context-Sensitive)

- **`02_flutter_development.mdc`** - General Flutter best practices (*.dart, pubspec.yaml)
- **`03_state_management.mdc`** - Bloc/Cubit guidelines (*bloc*.dart, *cubit*.dart, *state*.dart)
- **`04_theme_system.mdc`** - Theme and styling rules (*theme*.dart, *color*.dart, *typography*.dart)
- **`05_testing.mdc`** - Testing guidelines (*test*.dart, test/**)

### 📋 Manual Rules (On-Demand)

- **`06_code_generation.mdc`** - Code generation patterns (mention "code generation")
- **`08_project_setup.mdc`** - Project initialization (mention "project setup")

### 🚀 Agent-Requested Rules (Task-Specific)

- **`07_performance.mdc`** - Performance optimization (mention "performance", "optimization", "memory")

## Rule Types Explained

### 🔄 Always

- **When**: Attached to every chat and command request
- **Best for**: Core principles that should never be violated
- **Example**: Architecture fundamentals, dependency rules

### ⚡ Auto Attached

- **When**: Automatically attached based on file patterns
- **Best for**: Context-sensitive rules for specific file types
- **Example**: Flutter rules for .dart files, testing rules for test files

### 👤 Manual

- **When**: User needs to mention the rule to include it
- **Best for**: Specialized knowledge that's not always needed
- **Example**: Project setup, code generation workflows

### 🎯 Agent Requested

- **When**: Triggered by specific task descriptions
- **Best for**: Optimization and troubleshooting scenarios
- **Example**: Performance optimization, memory management

## Setting Up Rules in Cursor

### Option 1: Individual Files

Add each rule file separately in Cursor's rules section:

- Set appropriate rule type for each file
- Configure file patterns for auto-attached rules
- Add descriptions for agent-requested rules

### Option 2: Combined Setup

Create a master rule that references specific files based on context:

```markdown
# Master Flutter Rules

## Rule Type: Auto Attached
File pattern matches: *.dart, pubspec.yaml, *test*.dart

Include relevant rules based on context:
- Always include: Core Architecture (01_core_architecture.mdc)
- For .dart files: Flutter Development (02_flutter_development.mdc)
- For *bloc*/*cubit* files: State Management (03_state_management.mdc)
- For *theme* files: Theme System (04_theme_system.mdc)
- For *test* files: Testing (05_testing.mdc)
```

## Usage Examples

### Starting New Project

1. Mention "project setup" to activate setup rules
2. Core architecture rules are always active
3. Flutter development rules auto-attach to .dart files

### Working on Features

1. Core and Flutter rules are automatically active
2. State management rules attach when working with bloc/cubit files
3. Theme rules attach when working with styling

### Optimizing Performance

1. Mention "performance optimization" to activate performance rules
2. Get specific guidance for memory management and optimization

### Code Generation

1. Mention "code generation" to get build_runner guidance
2. Get freezed, injectable, and json_serializable patterns

## Benefits of Modular Approach

✅ **Focused Context**: Only relevant rules are active
✅ **Reduced Noise**: Avoid overwhelming the AI with irrelevant rules
✅ **Better Performance**: Smaller, focused rule sets
✅ **Easy Maintenance**: Update specific areas without affecting others
✅ **Flexible Usage**: Mix and match rules as needed
✅ **Team Collaboration**: Different team members can focus on relevant rules

## Maintenance

- Keep rules focused and concise
- Update file patterns as project structure evolves
- Regularly review and refine rule effectiveness
- Document changes and rule interactions
