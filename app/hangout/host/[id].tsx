import React, { useState, useMemo } from 'react';
import { StyleSheet, View, Text, TouchableOpacity, SafeAreaView, ScrollView, Switch } from 'react-native';
import { useLocalSearchParams, useRouter } from 'expo-router';
import { ChevronLeft, Info, CheckCircle, UserCheck, ShieldCheck } from 'lucide-react-native';
import { Colors, Spacing, BorderRadius, Typography } from '../../../theme';
import { SEEDED_HANGOUTS } from '../../../utils/seedData';

interface Participant {
  id: string;
  name: string;
  isPresent: boolean;
}

export default function HostDashboardScreen() {
  const { id } = useLocalSearchParams<{ id: string }>();
  const router = useRouter();

  const hangout = useMemo(() => 
    SEEDED_HANGOUTS.find(h => h.id === id) || SEEDED_HANGOUTS[0], 
  [id]);

  const [attendees, setAttendees] = useState<Participant[]>([
    { id: 'user_1', name: 'Arjun Singh', isPresent: true },
    { id: 'user_2', name: 'Priya Sharma', isPresent: true },
    { id: 'user_4', name: 'Rahul Varma', isPresent: false },
  ]);

  const toggleAttendance = (pId: string) => {
    setAttendees(prev => prev.map(p => 
      p.id === pId ? { ...p, isPresent: !p.isPresent } : p
    ));
  };

  const handleComplete = () => {
    // Logic to update Firestore & trigger rating notifications
    console.log('Hangout completed. Final attendees:', attendees.filter(a => a.isPresent).map(a => a.id));
    router.back();
  };

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.nav}>
        <TouchableOpacity style={styles.backButton} onPress={() => router.back()}>
          <ChevronLeft size={24} color={Colors.text} />
        </TouchableOpacity>
        <Text style={styles.navTitle}>Host Dashboard</Text>
        <View style={{ width: 40 }} />
      </View>

      <ScrollView contentContainerStyle={styles.content}>
        <View style={styles.header}>
          <Text style={styles.hangoutTitle}>{hangout.title}</Text>
          <View style={styles.statsCard}>
            <View style={styles.statItem}>
              <Text style={styles.statValue}>{attendees.length}</Text>
              <Text style={styles.statLabel}>Participants</Text>
            </View>
            <View style={styles.statDivider} />
            <View style={styles.statItem}>
              <Text style={styles.statValue}>{attendees.filter(a => a.isPresent).length}</Text>
              <Text style={styles.statLabel}>Present</Text>
            </View>
          </View>
        </View>

        <View style={styles.section}>
          <View style={styles.sectionHeader}>
            <Text style={styles.sectionTitle}>Mark Attendance</Text>
            <View style={styles.infoBadge}>
              <Info size={12} color={Colors.primary} />
              <Text style={styles.infoBadgeText}>Only present members can rate</Text>
            </View>
          </View>

          <View style={styles.list}>
            {attendees.map((p) => (
              <View key={p.id} style={styles.participantRow}>
                <View style={styles.participantInfo}>
                  <View style={styles.avatar}>
                    <Text style={styles.avatarText}>{p.name[0]}</Text>
                  </View>
                  <Text style={styles.participantName}>{p.name}</Text>
                </View>
                <Switch
                  trackColor={{ false: Colors.surface, true: Colors.primary }}
                  thumbColor={p.isPresent ? Colors.white : Colors.textMuted}
                  onValueChange={() => toggleAttendance(p.id)}
                  value={p.isPresent}
                />
              </View>
            ))}
          </View>
        </View>

        <View style={styles.trustBox}>
          <ShieldCheck size={20} color={Colors.accent} />
          <Text style={styles.trustText}>
            Accurate attendance marking builds your reputation as a trusted host.
          </Text>
        </View>
      </ScrollView>

      <View style={styles.footer}>
        <TouchableOpacity style={styles.completeButton} onPress={handleComplete}>
          <CheckCircle size={20} color={Colors.white} />
          <Text style={styles.buttonText}>Complete Hangout</Text>
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
  },
  header: {
    marginBottom: Spacing.xl,
  },
  hangoutTitle: {
    ...Typography.h2,
    marginBottom: Spacing.md,
  },
  statsCard: {
    flexDirection: 'row',
    backgroundColor: Colors.surface,
    borderRadius: BorderRadius.xl,
    padding: Spacing.lg,
    borderWidth: 1,
    borderColor: Colors.border,
    alignItems: 'center',
    justifyContent: 'space-around',
  },
  statItem: {
    alignItems: 'center',
  },
  statValue: {
    fontSize: 24,
    fontWeight: '700',
    color: Colors.primary,
  },
  statLabel: {
    fontSize: 12,
    color: Colors.textMuted,
    marginTop: 2,
    textTransform: 'uppercase',
  },
  statDivider: {
    width: 1,
    height: 30,
    backgroundColor: Colors.border,
  },
  section: {
    marginBottom: Spacing.xl,
  },
  sectionHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: Spacing.md,
  },
  sectionTitle: {
    ...Typography.h3,
  },
  infoBadge: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 4,
    backgroundColor: Colors.primary + '11',
    paddingHorizontal: 8,
    paddingVertical: 4,
    borderRadius: BorderRadius.sm,
  },
  infoBadgeText: {
    fontSize: 10,
    color: Colors.primary,
    fontWeight: '600',
  },
  list: {
    gap: Spacing.sm,
  },
  participantRow: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    backgroundColor: Colors.surface,
    padding: Spacing.md,
    borderRadius: BorderRadius.lg,
    borderWidth: 1,
    borderColor: Colors.border,
  },
  participantInfo: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: Spacing.sm,
  },
  avatar: {
    width: 36,
    height: 36,
    borderRadius: 18,
    backgroundColor: Colors.border,
    justifyContent: 'center',
    alignItems: 'center',
  },
  avatarText: {
    color: Colors.text,
    fontWeight: 'bold',
  },
  participantName: {
    color: Colors.text,
    fontSize: 16,
    fontWeight: '500',
  },
  trustBox: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: Colors.accent + '11',
    padding: Spacing.md,
    borderRadius: BorderRadius.lg,
    gap: Spacing.sm,
    borderWidth: 1,
    borderColor: Colors.accent + '22',
  },
  trustText: {
    flex: 1,
    fontSize: 13,
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
  completeButton: {
    backgroundColor: Colors.primary,
    height: 56,
    borderRadius: BorderRadius.lg,
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    gap: Spacing.sm,
  },
  buttonText: {
    color: Colors.white,
    fontWeight: 'bold',
    fontSize: 16,
  },
});
