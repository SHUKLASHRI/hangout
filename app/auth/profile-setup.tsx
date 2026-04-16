import React, { useState } from 'react';
import { StyleSheet, View, Text, TextInput, TouchableOpacity, SafeAreaView, ScrollView, KeyboardAvoidingView, Platform } from 'react-native';
import { useRouter } from 'expo-router';
import { User, Calendar, MapPin, ChevronRight } from 'lucide-react-native';
import { Colors, Spacing, BorderRadius, Typography } from '../../theme';

type Gender = 'Male' | 'Female' | 'Other';

export default function ProfileSetupScreen() {
  const router = useRouter();
  const [name, setName] = useState('');
  const [age, setAge] = useState('');
  const [gender, setGender] = useState<Gender | null>(null);

  const handleComplete = () => {
    if (name && age && gender) {
      // Here you would save the profile to Firestore
      console.log('Profile setup complete', { name, age, gender });
      router.replace('/(tabs)');
    }
  };

  const isFormValid = name && age && gender;

  return (
    <SafeAreaView style={styles.container}>
      <KeyboardAvoidingView 
        behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
        style={{ flex: 1 }}
      >
        <ScrollView contentContainerStyle={styles.content}>
          <View style={styles.header}>
            <Text style={styles.title}>About you</Text>
            <Text style={styles.subtitle}>Help others know who they're hanging out with.</Text>
          </View>

          <View style={styles.profileImageContainer}>
            <View style={styles.profilePlaceholder}>
              <User size={48} color={Colors.textMuted} />
            </View>
            <TouchableOpacity style={styles.addPhotoButton}>
              <Text style={styles.addPhotoText}>Add Photo</Text>
            </TouchableOpacity>
          </View>

          <View style={styles.form}>
            <View style={styles.inputGroup}>
              <Text style={styles.label}>Full Name</Text>
              <View style={styles.inputWrapper}>
                <User size={20} color={Colors.primary} style={styles.inputIcon} />
                <TextInput
                  style={styles.input}
                  placeholder="Arjun Singh"
                  placeholderTextColor={Colors.textMuted}
                  value={name}
                  onChangeText={setName}
                />
              </View>
            </View>

            <View style={styles.row}>
              <View style={[styles.inputGroup, { flex: 1 }]}>
                <Text style={styles.label}>Age</Text>
                <View style={styles.inputWrapper}>
                  <Calendar size={20} color={Colors.primary} style={styles.inputIcon} />
                  <TextInput
                    style={styles.input}
                    placeholder="24"
                    placeholderTextColor={Colors.textMuted}
                    keyboardType="number-pad"
                    value={age}
                    onChangeText={setAge}
                  />
                </View>
              </View>
            </View>

            <View style={styles.inputGroup}>
              <Text style={styles.label}>Gender</Text>
              <View style={styles.genderContainer}>
                {(['Male', 'Female', 'Other'] as Gender[]).map((g) => (
                  <TouchableOpacity
                    key={g}
                    style={[styles.genderChip, gender === g && styles.genderChipActive]}
                    onPress={() => setGender(g)}
                  >
                    <Text style={[styles.genderText, gender === g && styles.genderTextActive]}>
                      {g}
                    </Text>
                  </TouchableOpacity>
                ))}
              </View>
            </View>

            <View style={styles.inputGroup}>
              <Text style={styles.label}>Home Zone</Text>
              <View style={[styles.inputWrapper, styles.disabledInput]}>
                <MapPin size={20} color={Colors.textMuted} style={styles.inputIcon} />
                <Text style={styles.disabledText}>Automatically detected (Bangalore Central)</Text>
              </View>
              <Text style={styles.helperText}>Used for hangout notifications.</Text>
            </View>
          </View>

          <TouchableOpacity 
            style={[styles.button, !isFormValid && styles.buttonDisabled]}
            onPress={handleComplete}
            disabled={!isFormValid}
          >
            <Text style={styles.buttonText}>Get Started</Text>
            <ChevronRight size={20} color={Colors.white} />
          </TouchableOpacity>
        </ScrollView>
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
    padding: Spacing.lg,
    paddingBottom: Spacing.xxl,
  },
  header: {
    marginBottom: Spacing.xl,
  },
  title: {
    ...Typography.h1,
    marginBottom: Spacing.sm,
  },
  subtitle: {
    ...Typography.body,
    color: Colors.textMuted,
  },
  profileImageContainer: {
    alignItems: 'center',
    marginBottom: Spacing.xl,
  },
  profilePlaceholder: {
    width: 100,
    height: 100,
    borderRadius: 50,
    backgroundColor: Colors.surface,
    justifyContent: 'center',
    alignItems: 'center',
    borderWidth: 1,
    borderColor: Colors.border,
    marginBottom: Spacing.sm,
  },
  addPhotoButton: {
    padding: Spacing.xs,
  },
  addPhotoText: {
    color: Colors.primary,
    fontWeight: '600',
    fontSize: 14,
  },
  form: {
    gap: Spacing.lg,
    marginBottom: Spacing.xxl,
  },
  inputGroup: {
    gap: Spacing.xs,
  },
  label: {
    ...Typography.caption,
    color: Colors.primary,
    fontWeight: '600',
    textTransform: 'uppercase',
  },
  inputWrapper: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: Colors.surface,
    borderRadius: BorderRadius.lg,
    borderWidth: 1,
    borderColor: Colors.border,
    paddingHorizontal: Spacing.md,
  },
  inputIcon: {
    marginRight: Spacing.sm,
  },
  input: {
    flex: 1,
    height: 56,
    ...Typography.body,
    color: Colors.text,
  },
  row: {
    flexDirection: 'row',
    gap: Spacing.md,
  },
  genderContainer: {
    flexDirection: 'row',
    gap: Spacing.sm,
  },
  genderChip: {
    flex: 1,
    height: 48,
    borderRadius: BorderRadius.lg,
    backgroundColor: Colors.surface,
    justifyContent: 'center',
    alignItems: 'center',
    borderWidth: 1,
    borderColor: Colors.border,
  },
  genderChipActive: {
    backgroundColor: '#6366f122',
    borderColor: Colors.primary,
  },
  genderText: {
    color: Colors.textMuted,
    fontWeight: '600',
  },
  genderTextActive: {
    color: Colors.primary,
  },
  disabledInput: {
    backgroundColor: 'transparent',
    borderColor: Colors.border,
    borderStyle: 'dashed',
  },
  disabledText: {
    ...Typography.body,
    color: Colors.textMuted,
    fontSize: 14,
  },
  helperText: {
    fontSize: 12,
    color: Colors.textMuted,
    fontStyle: 'italic',
  },
  button: {
    backgroundColor: Colors.primary,
    height: 56,
    borderRadius: BorderRadius.lg,
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    gap: Spacing.sm,
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
