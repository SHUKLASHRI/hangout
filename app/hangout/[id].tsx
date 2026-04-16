import React, { useMemo } from 'react';
import { StyleSheet, View, Text, TouchableOpacity, SafeAreaView, ScrollView, Image } from 'react-native';
import { useLocalSearchParams, useRouter } from 'expo-router';
import { ChevronLeft, MapPin, Clock, Users, Shield, MessageCircle, Share2, AlertCircle } from 'lucide-react-native';
import { Colors, Spacing, BorderRadius, Typography } from '../../theme';
import { SEEDED_HANGOUTS } from '../../utils/seedData';
import { useAuth } from '../../context/AuthContext';
import { format, parseISO } from 'date-fns';

export default function HangoutDetailScreen() {
  const { id } = useLocalSearchParams<{ id: string }>();
  const router = useRouter();
  const { user, isGuest } = useAuth();

  const hangout = useMemo(() => 
    SEEDED_HANGOUTS.find(h => h.id === id) || SEEDED_HANGOUTS[0], 
  [id]);

  const isJoined = hangout.participants.includes(user?.uid || 'user_1'); // Mock check
  const isHost = user?.uid === hangout.hostId;
  const isFull = hangout.participants.length >= hangout.capacity;

  const handleJoin = () => {
    if (!user && !isGuest) {
      router.push('/auth/login');
      return;
    }
    // Join logic here
    console.log('User joining hangout:', id);
  };

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.nav}>
        <TouchableOpacity style={styles.navButton} onPress={() => router.back()}>
          <ChevronLeft size={24} color={Colors.text} />
        </TouchableOpacity>
        <TouchableOpacity style={styles.navButton}>
          <Share2 size={20} color={Colors.text} />
        </TouchableOpacity>
      </View>

      <ScrollView contentContainerStyle={styles.content}>
        <View style={styles.header}>
          <View style={styles.categoryBadge}>
            <Text style={styles.categoryText}>{hangout.category}</Text>
          </View>
          <Text style={styles.title}>{hangout.title}</Text>
          
          <View style={styles.metaRow}>
            <View style={styles.metaItem}>
              <Clock size={16} color={Colors.primary} />
              <Text style={styles.metaText}>
                {format(parseISO(hangout.startTime), 'EEE, MMM d • h:mm a')}
              </Text>
            </View>
            <View style={styles.metaItem}>
              <Users size={16} color={Colors.primary} />
              <Text style={styles.metaText}>
                {hangout.participants.length} / {hangout.capacity} joined
              </Text>
            </View>
          </View>
        </View>

        <View style={styles.section}>
          <Text style={styles.sectionTitle}>About this Hangout</Text>
          <Text style={styles.description}>{hangout.description}</Text>
        </View>

        <View style={styles.section}>
          <Text style={styles.sectionTitle}>Location</Text>
          <View style={styles.locationCard}>
            <MapPin size={24} color={Colors.primary} />
            <View style={styles.locationInfo}>
              <Text style={styles.locationName}>Approximate Location</Text>
              <Text style={styles.locationSuburb}>Central Bangalore Area</Text>
              {!isJoined && (
                <View style={styles.privacyHint}>
                  <Shield size={12} color={Colors.textMuted} />
                  <Text style={styles.privacyText}>Exact meeting point revealed after joining.</Text>
                </View>
              )}
            </View>
          </View>
          
          {isJoined && (
            <View style={styles.meetingPointBox}>
              <Text style={styles.meetingPointLabel}>MANDATORY MEETING POINT</Text>
              <Text style={styles.meetingPointText}>{hangout.meetingPoint}</Text>
            </View>
          )}
        </View>

        <View style={styles.section}>
          <Text style={styles.sectionTitle}>Host</Text>
          <View style={styles.hostCard}>
            <View style={styles.hostAvatar}>
              <Text style={styles.avatarText}>S</Text>
            </View>
            <View style={styles.hostInfo}>
              <Text style={styles.hostName}>Sagar Shukla</Text>
              <View style={styles.ratingRow}>
                <Text style={styles.ratingLabel}>Trust Rating:</Text>
                <Text style={styles.ratingValue}>4.8 / 5.0</Text>
              </View>
            </View>
          </View>
        </View>

        {isFull && !isJoined && (
          <View style={styles.fullWarning}>
            <AlertCircle size={16} color={Colors.secondary} />
            <Text style={styles.fullText}>This hangout has reached its capacity.</Text>
          </View>
        )}
      </ScrollView>

      <View style={styles.footer}>
        {isHost ? (
          <TouchableOpacity 
            style={styles.hostButton}
            onPress={() => router.push(`/hangout/host/${id}`)}
          >
            <Shield size={20} color={Colors.white} />
            <Text style={styles.buttonText}>Manage Attendance</Text>
          </TouchableOpacity>
        ) : isJoined ? (
          <View style={styles.participantActions}>
            <TouchableOpacity 
              style={styles.chatButton}
              onPress={() => router.push(`/hangout/chat/${id}`)}
            >
              <MessageCircle size={20} color={Colors.white} />
              <Text style={styles.buttonText}>Chat</Text>
            </TouchableOpacity>
            <TouchableOpacity 
              style={styles.rateButton}
              onPress={() => router.push(`/hangout/rate/${id}`)}
            >
              <Star size={20} color={Colors.white} />
              <Text style={styles.buttonText}>Rate</Text>
            </TouchableOpacity>
          </View>
        ) : (
          <TouchableOpacity 
            style={[styles.joinButton, isFull && styles.buttonDisabled]}
            disabled={isFull}
            onPress={handleJoin}
          >
            <Text style={styles.buttonText}>I'm Free</Text>
          </TouchableOpacity>
        )}
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
    justifyContent: 'space-between',
    padding: Spacing.md,
    zIndex: 10,
  },
  navButton: {
    width: 40,
    height: 40,
    borderRadius: 20,
    backgroundColor: Colors.surface,
    justifyContent: 'center',
    alignItems: 'center',
  },
  content: {
    padding: Spacing.lg,
    paddingBottom: 120,
  },
  header: {
    marginBottom: Spacing.xl,
  },
  categoryBadge: {
    backgroundColor: Colors.primary + '22',
    paddingHorizontal: Spacing.md,
    paddingVertical: Spacing.xs,
    borderRadius: BorderRadius.full,
    alignSelf: 'flex-start',
    marginBottom: Spacing.sm,
    borderWidth: 1,
    borderColor: Colors.primary + '44',
  },
  categoryText: {
    color: Colors.primary,
    fontSize: 12,
    fontWeight: '700',
    textTransform: 'uppercase',
  },
  title: {
    ...Typography.h1,
    marginBottom: Spacing.md,
  },
  metaRow: {
    flexDirection: 'row',
    gap: Spacing.lg,
  },
  metaItem: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 6,
  },
  metaText: {
    color: Colors.textMuted,
    fontSize: 14,
  },
  section: {
    marginBottom: Spacing.xl,
  },
  sectionTitle: {
    ...Typography.h3,
    marginBottom: Spacing.md,
  },
  description: {
    ...Typography.body,
    color: Colors.textMuted,
    lineHeight: 24,
  },
  locationCard: {
    flexDirection: 'row',
    backgroundColor: Colors.surface,
    padding: Spacing.md,
    borderRadius: BorderRadius.xl,
    gap: Spacing.md,
    alignItems: 'center',
    borderWidth: 1,
    borderColor: Colors.border,
  },
  locationInfo: {
    flex: 1,
  },
  locationName: {
    color: Colors.white,
    fontWeight: '600',
    fontSize: 16,
  },
  locationSuburb: {
    color: Colors.textMuted,
    fontSize: 14,
  },
  privacyHint: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 4,
    marginTop: 4,
  },
  privacyText: {
    fontSize: 11,
    color: Colors.textMuted,
    fontStyle: 'italic',
  },
  meetingPointBox: {
    marginTop: Spacing.md,
    backgroundColor: '#10b98111',
    padding: Spacing.md,
    borderRadius: BorderRadius.lg,
    borderWidth: 1,
    borderColor: '#10b98144',
  },
  meetingPointLabel: {
    fontSize: 10,
    fontWeight: '800',
    color: Colors.accent,
    marginBottom: 4,
  },
  meetingPointText: {
    color: Colors.text,
    fontSize: 16,
    fontWeight: '600',
  },
  hostCard: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: Colors.surface,
    padding: Spacing.md,
    borderRadius: BorderRadius.xl,
    gap: Spacing.md,
    borderWidth: 1,
    borderColor: Colors.border,
  },
  hostAvatar: {
    width: 50,
    height: 50,
    borderRadius: 25,
    backgroundColor: Colors.primary,
    justifyContent: 'center',
    alignItems: 'center',
  },
  avatarText: {
    color: Colors.white,
    fontWeight: 'bold',
    fontSize: 20,
  },
  hostName: {
    color: Colors.text,
    fontSize: 16,
    fontWeight: '600',
  },
  ratingRow: {
    flexDirection: 'row',
    gap: 4,
    marginTop: 2,
  },
  ratingLabel: {
    fontSize: 12,
    color: Colors.textMuted,
  },
  ratingValue: {
    fontSize: 12,
    color: Colors.secondary,
    fontWeight: '700',
  },
  fullWarning: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
    backgroundColor: Colors.secondary + '11',
    padding: Spacing.md,
    borderRadius: BorderRadius.lg,
    borderWidth: 1,
    borderColor: Colors.secondary + '22',
  },
  fullText: {
    color: Colors.secondary,
    fontSize: 14,
    flex: 1,
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
  joinButton: {
    backgroundColor: Colors.primary,
    height: 56,
    borderRadius: BorderRadius.lg,
    justifyContent: 'center',
    alignItems: 'center',
  },
  chatButton: {
    backgroundColor: Colors.surface,
    flex: 1,
    height: 56,
    borderRadius: BorderRadius.lg,
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    gap: Spacing.sm,
    borderWidth: 1,
    borderColor: Colors.border,
  },
  rateButton: {
    backgroundColor: Colors.secondary,
    flex: 1,
    height: 56,
    borderRadius: BorderRadius.lg,
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    gap: Spacing.sm,
  },
  hostButton: {
    backgroundColor: Colors.primary,
    height: 56,
    borderRadius: BorderRadius.lg,
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    gap: Spacing.sm,
  },
  participantActions: {
    flexDirection: 'row',
    gap: Spacing.md,
  },
  buttonDisabled: {
    backgroundColor: Colors.surface,
    opacity: 0.5,
  },
  buttonText: {
    color: Colors.white,
    fontWeight: 'bold',
    fontSize: 16,
  },
});
