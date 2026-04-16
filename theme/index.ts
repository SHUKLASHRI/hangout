export const Colors = {
  primary: '#6366f1', // Indigo
  secondary: '#f43f5e', // Rose
  accent: '#10b981', // Emerald
  background: '#0f172a', // Slate 900
  surface: '#1e293b', // Slate 800
  text: '#f8fafc', // Slate 50
  textMuted: '#94a3b8', // Slate 400
  border: '#334155', // Slate 700
  error: '#ef4444', // Red 500
  white: '#ffffff',
  black: '#000000',
  transparent: 'transparent',
};

export const Spacing = {
  xs: 4,
  sm: 8,
  md: 16,
  lg: 24,
  xl: 32,
  xxl: 48,
};

export const BorderRadius = {
  sm: 4,
  md: 8,
  lg: 12,
  xl: 16,
  full: 9999,
};

export const Typography = {
  h1: {
    fontSize: 32,
    fontWeight: '700' as const,
    color: Colors.text,
  },
  h2: {
    fontSize: 24,
    fontWeight: '700' as const,
    color: Colors.text,
  },
  h3: {
    fontSize: 20,
    fontWeight: '600' as const,
    color: Colors.text,
  },
  body: {
    fontSize: 16,
    color: Colors.text,
  },
  caption: {
    fontSize: 12,
    color: Colors.textMuted,
  },
};
