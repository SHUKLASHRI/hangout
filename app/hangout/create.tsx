import React, { useState } from 'react';
import { StyleSheet, View, Text, TextInput, TouchableOpacity, SafeAreaView, ScrollView, Switch, KeyboardAvoidingView, Platform } from 'react-native';
import { useRouter } from 'expo-router';
import { ChevronLeft, Info, Calendar, Clock, MapPin, Users, Check } from 'lucide-react-native';
import { Colors, Spacing, BorderRadius, Typography } from '../../theme';

type Category = 'Social' | 'Gaming' | 'Creative' | 'Sports' | 'Food' | 'Others';

export default function CreateHangoutScreen() {
  const router = useRouter();
  const [title, setTitle] = useState('');
  const [description, setDescription] = useState('');
  const [category, setCategory] = useState<Category>('Social');
  const [capacity, setCapacity] = useState('5');
  const [meetingPoint, setMeetingPoint] = useState('');

  const handleCreate = () => {
    if (title && description && meetingPoint) {
      // Logic to save to Firestore
      console.log('Hangout created', { title, category, meetingPoint });
      router.back();
    }
  };

  const isFormValid = title && description && meetingPoint;

  return (
    <SafeAreaView style={styles.container}>
      <KeyboardAvoidingView 
        behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
        style={{ flex: 1 }}
      >
        <View style={styles.nav}>
          <TouchableOpacity style={styles.backButton} onPress={() => router.back()}>
            <ChevronLeft size={24} color={Colors.text} />
          </TouchableOpacity>
          <Text style={styles.navTitle}>Create Hangout</Text>
          <View style={{ width: 40 }} />
        </View>

        <ScrollView contentContainerStyle={styles.content}>
          <View style={styles.form}>
            <View style={styles.inputGroup}>
              <Text style={styles.label}>Title</Text>
              <TextInput
                style={styles.input}
                placeholder="Chai + Walk at Cubbon Park"
                placeholderTextColor={Colors.textMuted}
                value={title}
                onChangeText={setTitle}
              />
            </View>

            <View style={styles.inputGroup}>
              <Text style={styles.label}>Category</Text>
              <View style={styles.categoryGrid}>
                {(['Social', 'Gaming', 'Creative', 'Sports', 'Food', 'Others'] as Category[]).map((cat) => (
                  <TouchableOpacity
                    key={cat}
                    style={[styles.categoryChip, category === cat && styles.categoryChipActive]}
                    onPress={() => setCategory(cat)}
                  >
                    <Text style={[styles.categoryText, category === cat && styles.categoryTextActive]}>
                      {cat}
                    </Text>
                  </TouchableOpacity>
                ))}
              </View>
            </View>

            <View style={styles.inputGroup}>
              <Text style={styles.label}>Description</Text>
              <TextInput
                style={[styles.input, styles.textArea]}
                placeholder="Tell people what to expect..."
                placeholderTextColor={Colors.textMuted}
                multiline
                numberOfLines={4}
                value={description}
                onChangeText={setDescription}
              />
            </View>

            <View style={styles.row}>
              <View style={[styles.inputGroup, { flex: 1 }]}>
                <Text style={styles.label}>Max Capacity</Text>
                <View style={styles.inputWrapper}>
                  <Users size={20} color={Colors.primary} style={styles.inputIcon} />
                  <TextInput
                    style={styles.inputCompact}
                    placeholder="10"
                    placeholderTextColor={Colors.textMuted}
                    keyboardType="number-pad"
                    value={capacity}
                    onChangeText={setCapacity}
                  />
                </View>
              </View>
            </View>

            <View style={styles.inputGroup}>
              <View style={styles.labelHeader}>
                <Text style={styles.label}>Meeting Point</Text>
                <View style={styles.requiredBadge}><Text style={styles.requiredText}>MANDATORY</Text></View>
              </View>
              <View style={styles.inputWrapper}>
                <MapPin size={20} color={Colors.primary} style={styles.inputIcon} />
                <TextInput
                  style={styles.inputCompact}
                  placeholder="Gate 2 near the band stand"
                  placeholderTextColor={Colors.textMuted}
                  value={meetingPoint}
                  onChangeText={setMeetingPoint}
                />
              </View>
              <Text style={styles.helperText}>Visible only to joined participants.</Text>
            </View>

            <View style={styles.infoBox}>
              <Info size={16} color={Colors.primary} />
              <Text style={styles.infoText}>
                The meeting point must be set at least 1 hour before the hangout starts.
              </Text>
            </View>
          </View>
        </ScrollView>

        <View style={styles.footer}>
          <TouchableOpacity 
            style={[styles.button, !isFormValid && styles.buttonDisabled]}
            onPress={handleCreate}
            disabled={!isFormValid}
          >
            <Check size={20} color={Colors.white} />
            <Text style={styles.buttonText}>Launch Hangout</Text>
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
  nav: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: Spacing.md,
    paddingVertical: Spacing.sm,
    borderBottomWidth: 1,
    borderBottomColor: Colors.border,
  },
  navTitle: {
    ...Typography.h3,
    color: Colors.text,
  },
  backButton: {
    width: 40,
    height: 40,
    borderRadius: BorderRadius.full,
    backgroundColor: Colors.surface,
    justifyContent: 'center',
    alignItems: 'center',
  },
  content: {
    padding: Spacing.lg,
  },
  form: {
    gap: Spacing.lg,
    paddingBottom: 100,
  },
  inputGroup: {
    gap: Spacing.xs,
  },
  labelHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  label: {
    ...Typography.caption,
    color: Colors.primary,
    fontWeight: '600',
    textTransform: 'uppercase',
  },
  requiredBadge: {
    backgroundColor: Colors.secondary + '22',
    paddingHorizontal: 6,
    paddingVertical: 2,
    borderRadius: BorderRadius.sm,
  },
  requiredText: {
    fontSize: 10,
    color: Colors.secondary,
    fontWeight: '700',
  },
  input: {
    backgroundColor: Colors.surface,
    borderRadius: BorderRadius.lg,
    borderWidth: 1,
    borderColor: Colors.border,
    paddingHorizontal: Spacing.md,
    height: 56,
    color: Colors.text,
    ...Typography.body,
  },
  textArea: {
    height: 120,
    paddingTop: Spacing.sm,
    textAlignVertical: 'top',
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
  inputCompact: {
    flex: 1,
    height: 56,
    color: Colors.text,
    ...Typography.body,
  },
  categoryGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: Spacing.sm,
  },
  categoryChip: {
    paddingHorizontal: Spacing.md,
    paddingVertical: Spacing.sm,
    borderRadius: BorderRadius.full,
    backgroundColor: Colors.surface,
    borderWidth: 1,
    borderColor: Colors.border,
  },
  categoryChipActive: {
    backgroundColor: Colors.primary,
    borderColor: Colors.primary,
  },
  categoryText: {
    color: Colors.textMuted,
    fontWeight: '600',
    fontSize: 14,
  },
  categoryTextActive: {
    color: Colors.white,
  },
  row: {
    flexDirection: 'row',
    gap: Spacing.md,
  },
  helperText: {
    fontSize: 12,
    color: Colors.textMuted,
    fontStyle: 'italic',
  },
  infoBox: {
    flexDirection: 'row',
    backgroundColor: Colors.surface,
    padding: Spacing.md,
    borderRadius: BorderRadius.lg,
    gap: Spacing.sm,
    borderWidth: 1,
    borderColor: Colors.border,
  },
  infoText: {
    flex: 1,
    fontSize: 12,
    color: Colors.textMuted,
    lineHeight: 18,
  },
  footer: {
    position: 'absolute',
    bottom: 0,
    left: 0,
    right: 0,
    padding: Spacing.lg,
    backgroundColor: Colors.background,
    borderTopWidth: 1,
    borderTopColor: Colors.border,
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
