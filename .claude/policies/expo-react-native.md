# Expo/React Native Development Guidelines

## Overview

These guidelines provide a comprehensive approach to developing high-quality, performant, and maintainable mobile applications using Expo and React Native.

## 1. Project Setup and Configuration

### 1.1 TypeScript Configuration
- Always use TypeScript with strict mode enabled
- Configure `tsconfig.json` with the following recommended settings:
```json
{
  "compilerOptions": {
    "strict": true,
    "noImplicitAny": true,
    "strictNullChecks": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true
  }
}
```

### 1.2 Development Environment
- Use the latest stable version of Expo CLI
- Recommended development tools:
  - Visual Studio Code with recommended React Native extensions
  - ESLint for code linting
  - Prettier for code formatting
  - React Native Debugger

## 2. Code Structure and Architecture

### 2.1 Project Organization
- Use a modular, feature-based directory structure:

> **Project-specific (example)**: This policy assumes the mobile app root is `/apps/mobile`. Change this to match your repository. All paths below are relative to that directory (e.g., `/apps/mobile/src/components`).

```
/src
  /components
  /screens
  /navigation
  /services
  /utils
  /types
  /hooks
  /state
```

### 2.2 State Management
- Prefer Zustand or Redux Toolkit for complex state management
- Use React Context for lighter, more localized state
- Implement strict type definitions for all state shapes

### 2.3 Component Design
- Favor functional components with hooks
- Use composition over inheritance
- Create generic, reusable components
- Implement prop type validation

```typescript
interface ButtonProps {
  label: string;
  onPress: () => void;
  variant?: 'primary' | 'secondary';
}

const Button: React.FC<ButtonProps> = ({ 
  label, 
  onPress, 
  variant = 'primary' 
}) => {
  // Component implementation
}
```

## 3. Performance Optimization

### 3.1 Rendering Strategies
- Use `React.memo()` for preventing unnecessary re-renders
- Implement `useMemo()` and `useCallback()` for complex calculations and event handlers
- Lazy load components and screens when possible

### 3.2 Bundle Optimization
- Use Expo's code splitting features
- Minimize third-party library imports
- Use dynamic imports for large dependencies

## 4. Error Handling and Logging

### 4.1 Error Boundaries
- Implement global and local error boundaries
- Use Sentry or similar service for error tracking

```typescript
class ErrorBoundary extends React.Component<{}, { hasError: boolean }> {
  state = { hasError: false };

  static getDerivedStateFromError() {
    return { hasError: true };
  }

  componentDidCatch(error: Error, errorInfo: React.ErrorInfo) {
    logErrorToService(error, errorInfo);
  }

  render() {
    if (this.state.hasError) {
      return <FallbackComponent />;
    }
    return this.props.children;
  }
}
```

## 5. Testing Strategies

### 5.1 Testing Types
- Unit Tests: Jest
- Integration Tests: React Native Testing Library
- End-to-End Tests: Detox

### 5.2 Test Coverage
- Aim for 80%+ test coverage
- Test critical paths and edge cases
- Mock external dependencies

## 6. Platform Considerations

### 6.1 Cross-Platform Development
- Use platform-specific code sparingly
- Leverage Expo's cross-platform APIs
- Test thoroughly on both iOS and Android

```typescript
import { Platform } from 'react-native';

const styles = {
  ...Platform.select({
    ios: { /* iOS specific styles */ },
    android: { /* Android specific styles */ }
  })
};
```

## 7. Safe Area Handling

### 7.1 Overview
Safe areas ensure your app's content is positioned correctly and doesn't get overlapped by device-specific UI elements like notches, status bars, home indicators, rounded corners, and other interface elements controlled by the operating system.

### 7.2 Prefer `useSafeAreaInsets` Hook Over SafeAreaView

While `SafeAreaView` is a valid approach, the `useSafeAreaInsets` hook provides more flexibility and control over safe area handling. Use the hook as the primary method for managing safe areas in your components.

#### Why `useSafeAreaInsets` is Preferred:
- **Granular Control**: Apply insets selectively to specific edges
- **Dynamic Layouts**: Conditionally apply safe area padding based on content
- **Performance**: More efficient than wrapping components in additional views
- **Flexibility**: Works with any layout component, not just views
- **Custom Logic**: Combine insets with other layout calculations

### 7.3 Implementation Patterns

#### Basic Usage Pattern
```typescript
import { View, Text, StyleSheet } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

const ScreenComponent: React.FC = () => {
  const insets = useSafeAreaInsets();

  return (
    <View style={[styles.container, { paddingTop: insets.top }]}>
      <Text>Content is properly positioned</Text>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
  },
});
```

#### Selective Edge Application
```typescript
import { View, Text, StyleSheet } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

const HeaderComponent: React.FC = () => {
  const insets = useSafeAreaInsets();

  return (
    <View style={[
      styles.header,
      {
        // Only apply top and horizontal insets for headers
        paddingTop: insets.top,
        paddingLeft: insets.left,
        paddingRight: insets.right,
        // Deliberately exclude bottom inset
      }
    ]}>
      <Text>Header Content</Text>
    </View>
  );
};
```

#### Conditional Safe Area Application
```typescript
import { View, Text, StyleSheet, Platform } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

interface ScreenWrapperProps {
  children: React.ReactNode;
  excludeBottom?: boolean;
  excludeTop?: boolean;
}

const ScreenWrapper: React.FC<ScreenWrapperProps> = ({ 
  children, 
  excludeBottom = false,
  excludeTop = false 
}) => {
  const insets = useSafeAreaInsets();

  const dynamicPadding = {
    paddingTop: excludeTop ? 0 : insets.top,
    paddingBottom: excludeBottom ? 0 : insets.bottom,
    paddingLeft: insets.left,
    paddingRight: insets.right,
  };

  return (
    <View style={[styles.wrapper, dynamicPadding]}>
      {children}
    </View>
  );
};
```

#### Custom Hook for Consistent Usage
```typescript
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { ViewStyle } from 'react-native';

interface SafeAreaOptions {
  top?: boolean;
  bottom?: boolean;
  left?: boolean;
  right?: boolean;
}

export const useSafeAreaStyle = (options: SafeAreaOptions = {}): ViewStyle => {
  const insets = useSafeAreaInsets();
  const { top = true, bottom = true, left = true, right = true } = options;

  return {
    paddingTop: top ? insets.top : 0,
    paddingBottom: bottom ? insets.bottom : 0,
    paddingLeft: left ? insets.left : 0,
    paddingRight: right ? insets.right : 0,
  };
};

// Usage in component
const MyScreen: React.FC = () => {
  const safeAreaStyle = useSafeAreaStyle({ bottom: false });

  return (
    <View style={[styles.container, safeAreaStyle]}>
      <Text>Content with custom safe area</Text>
    </View>
  );
};
```

### 7.4 Common Patterns and Use Cases

#### Screen-Level Components
```typescript
// Apply full safe area padding for main content screens
const safeAreaStyle = useSafeAreaStyle();

// For screens with custom navigation, exclude top
const safeAreaStyle = useSafeAreaStyle({ top: false });

// For modal screens, typically exclude bottom for gesture handling
const safeAreaStyle = useSafeAreaStyle({ bottom: false });
```

#### Header Components
```typescript
// Headers typically need top and horizontal padding only
const headerSafeAreaStyle = useSafeAreaStyle({ bottom: false });
```

#### Footer/Tab Bar Components
```typescript
// Footers and tab bars typically need bottom and horizontal padding
const footerSafeAreaStyle = useSafeAreaStyle({ top: false });
```

#### Full-Screen Components (Videos, Images)
```typescript
// Full-screen content often needs no safe area padding
// Handle safe areas in overlay UI elements instead
const fullScreenStyle = useSafeAreaStyle({ 
  top: false, 
  bottom: false, 
  left: false, 
  right: false 
});
```

### 7.5 Integration with Navigation

When using with Expo Router or React Navigation, coordinate safe area handling:

```typescript
import { Stack } from 'expo-router';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

export default function Layout() {
  const insets = useSafeAreaInsets();

  return (
    <Stack
      screenOptions={{
        headerShown: false, // Handle header safe areas manually
        contentStyle: {
          paddingTop: insets.top, // Apply consistent top padding
        },
      }}
    />
  );
}
```

### 7.6 Best Practices

#### Do:
- Use `useSafeAreaInsets` as the primary safe area solution
- Create reusable custom hooks for common safe area patterns
- Test thoroughly on devices with different safe area requirements (iPhone 14 Pro, iPhone SE, various Android devices)
- Apply safe areas at the screen level rather than individual components when possible
- Consider content context when deciding which edges need safe area padding

#### Don't:
- Mix `SafeAreaView` and `useSafeAreaInsets` arbitrarily in the same component
- Apply safe area padding to every component - be selective based on UI requirements
- Forget to account for keyboard safe area on Android when using bottom insets
- Hardcode safe area values - always use the hook for dynamic values

### 7.7 Common Mistakes to Avoid

1. **Double Padding**: Avoid applying safe area padding when React Navigation already handles it
2. **Ignoring Content Context**: Not all content needs full safe area treatment (e.g., background images)
3. **Platform Assumptions**: Don't assume safe areas only affect iOS - Android devices have various configurations
4. **Static Values**: Never use hardcoded values instead of the dynamic insets from the hook
5. **Keyboard Interference**: Be aware that bottom safe areas can interfere with keyboard handling

### 7.8 Testing Safe Areas

- Test on physical devices with different safe area configurations
- Use iOS Simulator with different device types (iPhone 14 Pro, iPhone SE, iPad)
- Test Android devices with different navigation bar configurations
- Use Expo development tools to preview different device layouts
- Test landscape orientation where safe areas change significantly

### 7.9 Performance Considerations

- The `useSafeAreaInsets` hook automatically updates when device orientation changes
- Values are memoized within the context provider for performance
- Avoid creating new style objects on every render - use `useMemo` for complex calculations:

```typescript
const safeAreaStyle = useMemo(() => ({
  paddingTop: insets.top,
  paddingBottom: insets.bottom,
  // ... other complex calculations
}), [insets.top, insets.bottom]);
```

**Reference**: [Expo Safe Areas Documentation](https://docs.expo.dev/develop/user-interface/safe-areas/#alternate-usesafeareainsets-hook)

## 8. Deployment and CI/CD

### 8.1 Build Configurations
- Use Expo EAS (Expo Application Services) for builds
- Implement separate configurations for development, staging, and production
- Use environment variables for configuration management

## 9. Security Best Practices

### 9.1 Data Protection
- Never store sensitive information in plain text
- Use secure storage mechanisms
- Implement proper authentication flows
- Sanitize and validate all user inputs

## 10. Accessibility

### 10.1 A11y Guidelines
- Add accessibility labels to all interactive components
- Ensure color contrast meets WCAG standards
- Support screen readers and alternative input methods

## 11. Common Mistakes to Avoid

- Overusing global state
- Neglecting performance optimization
- Ignoring platform-specific behaviors
- Skipping type checking
- Inadequate error handling
- Inconsistent safe area handling across screens
- Using hardcoded safe area values instead of `useSafeAreaInsets`
- Applying unnecessary safe area padding to all components

## Escalation Procedures

1. Performance issues: Profile and optimize
2. Persistent bugs: Comprehensive debugging session
3. Architecture challenges: Consult technical architect
4. Complex integrations: Pair programming or external consultation

## Appendix: Recommended Tools and Libraries

- State Management: Zustand, Redux Toolkit
- Navigation: React Navigation
- Forms: Formik, React Hook Form
- Testing: Jest, React Native Testing Library, Detox
- Styling: Tailwind CSS, Styled Components
- Utilities: Lodash, Date-fns

## Versioning and Updates

- Review and update these guidelines quarterly
- Keep aligned with latest Expo and React Native best practices
- Incorporate team learnings and emerging patterns

---

**Last Updated:** 2025-09-12  
**Version:** 1.0.0