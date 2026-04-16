import React, { useState, useMemo } from 'react';
import { StyleSheet, View, Text, TouchableOpacity, SafeAreaView, TextInput, ScrollView } from 'react-native';
import { useLocalSearchParams, useRouter } from 'expo-router';
import { ChevronLeft, Star, Heart, MessageSquare, Send } from 'lucide-react-native';
import { Colors, Spacing, BorderRadius, Typography } from '../../../theme';
import { SEEDED_HANGOUTS } from '../../../utils/seedData';

export default function RatingScreen() {
  const { id } = useLocalSearchParams<{ id: string }>();
  const router = useRouter();
  const [rating, setRating] = useState(0);
  const [comment, setComment] = useState('');

  const hangout = useMemo(() => 
    SEEDED_HANGOUTS.find(h => h.id === id) || SEEDED_HANGOUTS[0], 
  [id]);

  const handleSubmit = () => {
    if (rating > 0) {
      console.log('Rating submitted:', { hangoutId: id, rating, comment });
      router.replace('/(tabs)');
    }
  };

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.nav}>
        <TouchableOpacity style={styles.backButton} onPress={() => router.back()}>
          <ChevronLeft size={24} color={Colors.text} />
        </TouchableOpacity>
        <Text style={styles.navTitle}>End of Hangout</Text>
        <View style={{ width: 40 }} />
      </View>

      <ScrollView contentContainerStyle={styles.content}>
        <View style={styles.header}>
          <View style={styles.successIcon}>
            <Heart size={48} color={Colors.white} fill={Colors.secondary} />
          </View>
          <Text style={styles.title}>How was the hangout?</Text>
          <Text style={styles.subtitle}>
            Rate your experience with "{hangout.title}". Your feedback helps build a safer community.
          </Text>
        </View>

        <View style={styles.ratingSection}>
          <Text style={styles.sectionLabel}>Rate the Host & Experience</Text>
          <View style={styles.starsContainer}>
            {[1, 2, 3, 4, 5].map((s) => (
              <TouchableOpacity
                key={s}
                onPress={() => setRating(s)}
                style={styles.starTouch}
              >
                <Star
                  size={40}
                  color={s <= rating ? Colors.secondary : Colors.textMuted}
                  fill={s <= rating ? Colors.secondary : 'transparent'}
                />
              </TouchableOpacity>
            ))}
          </View>
          <Text style={styles.ratingDescriptor}>
            {rating === 5 ? 'Excellent!' : rating === 4 ? 'Great!' : rating === 3 ? 'Good' : rating === 2 ? 'Fair' : rating === 1 ? 'Poor' : 'Select a rating'}
          </Text>
        </View>

        <View style={styles.inputSection}>
          <Text style={styles.sectionLabel}>Add a Review (Optional)</Text>
          <View style={styles.inputWrapper}>
            <MessageSquare size={18} color={Colors.primary} style={styles.inputIcon} />
            <TextInput
              style={styles.input}
              placeholder="What did you like? Any suggestions?"
              placeholderTextColor={Colors.textMuted}
              multiline
              numberOfLines={4}
              value={comment}
              onChangeText={setComment}
            />
          </View>
        </View>

        <View style={styles.warningBox}>
          <Text style={styles.warningText}>
            Ratings influence visibility and access. Be honest and constructive.
          </Text>
        </View>
      </ScrollView>

      <View style={styles.footer}>
        <TouchableOpacity 
          style={[styles.submitButton, rating === 0 && styles.buttonDisabled]} 
          onPress={handleSubmit}
          disabled={rating === 0}
        >
          <Text style={styles.buttonText}>Submit Review</Text>
          <Send size={18} color={Colors.white} />
        </TouchableOpacity>
      </View>
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
    alignItems: 'center',
  },
  header: {
    alignItems: 'center',
    marginBottom: Spacing.xxl,
    textAlign: 'center',
  },
  successIcon: {
    width: 100,
    height: 100,
    borderRadius: 50,
    backgroundColor: Colors.secondary + '22',
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: Spacing.lg,
  },
  title: {
    ...Typography.h1,
    textAlign: 'center',
    marginBottom: Spacing.sm,
  },
  subtitle: {
    ...Typography.body,
    color: Colors.textMuted,
    textAlign: 'center',
    paddingHorizontal: Spacing.md,
  },
  ratingSection: {
    width: '100%',
    alignItems: 'center',
    marginBottom: Spacing.xxl,
  },
  sectionLabel: {
    ...Typography.caption,
    color: Colors.primary,
    fontWeight: '700',
    marginBottom: Spacing.md,
    textTransform: 'uppercase',
  },
  starsContainer: {
    flexDirection: 'row',
    gap: Spacing.sm,
  },
  starTouch: {
    padding: Spacing.xs,
  },
  ratingDescriptor: {
    marginTop: Spacing.sm,
    fontSize: 16,
    fontWeight: '600',
    color: Colors.secondary,
  },
  inputSection: {
    width: '100%',
    marginBottom: Spacing.xl,
  },
  inputWrapper: {
    flexDirection: 'row',
    backgroundColor: Colors.surface,
    borderRadius: BorderRadius.lg,
    borderWidth: 1,
    borderColor: Colors.border,
    padding: Spacing.md,
  },
  inputIcon: {
    marginRight: Spacing.sm,
    marginTop: 2,
  },
  input: {
    flex: 1,
    ...Typography.body,
    color: Colors.text,
    minHeight: 100,
    textAlignVertical: 'top',
  },
  warningBox: {
    backgroundColor: Colors.surface,
    padding: Spacing.md,
    borderRadius: BorderRadius.lg,
    borderWidth: 1,
    borderColor: Colors.border,
    borderStyle: 'dashed',
  },
  warningText: {
    fontSize: 12,
    color: Colors.textMuted,
    textAlign: 'center',
    fontStyle: 'italic',
  },
  footer: {
    padding: Spacing.lg,
    borderTopWidth: 1,
    borderTopColor: Colors.border,
  },
  submitButton: {
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
