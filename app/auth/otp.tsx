import React, { useState, useEffect } from 'react';
import { StyleSheet, View, Text, TextInput, TouchableOpacity, SafeAreaView, KeyboardAvoidingView, Platform } from 'react-native';
import { useRouter, useLocalSearchParams } from 'expo-router';
import { ChevronLeft, Lock } from 'lucide-react-native';
import { Colors, Spacing, BorderRadius, Typography } from '../../theme';
import { useAuth } from '../../context/AuthContext';

export default function OTPScreen() {
  const router = useRouter();
  const { phone } = useLocalSearchParams<{ phone: string }>();
  const [otp, setOtp] = useState('');
  const { setGuest } = useAuth();

  const handleVerify = () => {
    if (otp.length === 6) {
      // Logic for Firebase verification would go here
      // For MVP, we simulate success
      console.log('OTP Verified for:', phone);
      // Navigate to profile setup
      router.push('/auth/profile-setup');
    }
  };

  return (
    <SafeAreaView style={styles.container}>
      <KeyboardAvoidingView 
        behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
        style={styles.content}
      >
        <TouchableOpacity style={styles.backButton} onPress={() => router.back()}>
          <ChevronLeft size={24} color={Colors.text} />
        </TouchableOpacity>

        <View style={styles.header}>
          <View style={styles.iconContainer}>
            <Lock size={32} color={Colors.primary} />
          </View>
          <Text style={styles.title}>Verify it's you</Text>
          <Text style={styles.subtitle}>Enter the 6-digit code sent to +91 {phone}</Text>
        </View>

        <View style={styles.inputContainer}>
          <Text style={styles.label}>OTP Code</Text>
          <TextInput
            style={styles.otpInput}
            placeholder="000 000"
            placeholderTextColor={Colors.textMuted}
            keyboardType="number-pad"
            autoFocus
            value={otp}
            onChangeText={setOtp}
            maxLength={6}
            letterSpacing={8}
          />
        </View>

        <View style={styles.footer}>
          <TouchableOpacity style={styles.resendButton}>
            <Text style={styles.resendText}>Didn't receive code? Resend</Text>
          </TouchableOpacity>

          <TouchableOpacity 
            style={[styles.button, otp.length < 6 && styles.buttonDisabled]}
            onPress={handleVerify}
            disabled={otp.length < 6}
          >
            <Text style={styles.buttonText}>Verify & Continue</Text>
          </TouchableOpacity>
        </View>
      </KeyboardAvoidingView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: Colors.background,
  },
  content: {
    flex: 1,
    padding: Spacing.lg,
  },
  backButton: {
    width: 40,
    height: 40,
    borderRadius: BorderRadius.full,
    backgroundColor: Colors.surface,
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: Spacing.xl,
  },
  header: {
    marginBottom: Spacing.xxl,
  },
  iconContainer: {
    width: 64,
    height: 64,
    borderRadius: BorderRadius.xl,
    backgroundColor: Colors.surface,
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: Spacing.md,
    borderWidth: 1,
    borderColor: Colors.border,
  },
  title: {
    ...Typography.h1,
    marginBottom: Spacing.sm,
  },
  subtitle: {
    ...Typography.body,
    color: Colors.textMuted,
  },
  inputContainer: {
    marginBottom: Spacing.xl,
  },
  label: {
    ...Typography.caption,
    color: Colors.primary,
    fontWeight: '600',
    marginBottom: Spacing.xs,
    textTransform: 'uppercase',
  },
  otpInput: {
    backgroundColor: Colors.surface,
    borderRadius: BorderRadius.lg,
    borderWidth: 1,
    borderColor: Colors.border,
    height: 64,
    ...Typography.h2,
    color: Colors.text,
    textAlign: 'center',
    paddingHorizontal: Spacing.md,
  },
  footer: {
    marginTop: 'auto',
    gap: Spacing.md,
  },
  resendButton: {
    alignItems: 'center',
  },
  resendText: {
    color: Colors.textMuted,
    fontSize: 14,
  },
  button: {
    backgroundColor: Colors.primary,
    height: 56,
    borderRadius: BorderRadius.lg,
    justifyContent: 'center',
    alignItems: 'center',
  },
  buttonDisabled: {
    opacity: 0.5,
  },
  buttonText: {
    color: Colors.white,
    fontWeight: 'bold',
    fontSize: 16,
  },
});
